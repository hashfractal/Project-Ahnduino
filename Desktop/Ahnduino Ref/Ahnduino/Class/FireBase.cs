using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.IO;
using Google.Cloud.Firestore;
using System.Drawing;
using FirebaseAdmin.Auth;
using Newtonsoft.Json.Linq;


namespace Ahnduino
{
	internal class FireBase
	{
		public FirestoreDb DB;

		public FireBase()
		{
			string path = "ahnduino-firebase-adminsdk-ddl6q-daf19142ac.json";
			System.Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", path);

			DB = FirestoreDb.Create("ahnduino");
		}

		public void CreateUser(string email)
		{
			/*
			 * 이메일받아옴
			 * 컬렉션 생성 함수 호출
			 * 
			 */
		}

		public string getEmail(string address)
		{
			CollectionReference colref = DB.Collection("User");
			Query query = colref.WhereEqualTo("주소", address);
			QuerySnapshot qusnap = query.GetSnapshotAsync().Result;
			DocumentSnapshot docsnap = qusnap[0];

			return docsnap.Id;
		}

		public string GetAddress(string email)
		{
			CollectionReference cref = DB.Collection("User");
			Query query = cref.WhereEqualTo("메일", email);
			QuerySnapshot qsnap = query.GetSnapshotAsync().Result;
			DocumentSnapshot dsnap = qsnap[0];

			Dictionary<string, object> dic = dsnap.ToDictionary();

			dic.TryGetValue("주소", out object temp);

			return temp.ToString();
		}

		#region Request
		public List<string> GetRequestList()
		{
			List<string> res = new List<string>();

			CollectionReference colref = DB.Collection("ResponsAndReQuest");
			IAsyncEnumerable<DocumentReference> endoccref = colref.ListDocumentsAsync();
			List<DocumentReference> docrefs = endoccref.ToListAsync().Result;

			foreach(DocumentReference i in docrefs)
			{
				IAsyncEnumerable<CollectionReference> encolef = i.Collection("Request").Document("Request").ListCollectionsAsync();
				List<CollectionReference> colrefs = encolef.ToListAsync().Result;
				foreach(CollectionReference j in colrefs)
				{
					if(j.Id.Substring(10, 4) == "예약 전")
					{
						res.Add(i.Id /*GetAddress(i.id)*/ + " " + j.Id.Substring(0,10));
					}
				}
			}

			return res;
		}

		public List<string> GetUserRequestList()
		{
			List<string> res = new List<string>();
		}

		public Request GetRequest()
		{

		}


		#endregion

		#region Chat
		public List<string> getChatList()
		{
			List<string> res = new List<string>();

			DocumentReference docref = DB.Collection("chat").Document("chat");

			IAsyncEnumerable<CollectionReference> ascref = docref.ListCollectionsAsync();
			List<CollectionReference> colrefs = ascref.ToListAsync().Result;
			
			foreach(CollectionReference i in colrefs)
			{
				res.Add(i.Id);
			}
			return res;
		}
		#endregion

		#region Bill
		public void createnewbill(string address)
		{
			/*
			 * getemail 로 이메일 받아옴
			 * Bill 컬렉션에 이메일 문서생성
			 * 문서 작성
			 * 
			 */
		}

		public List<Bill> GetBillList(string address, out int paypermonth)
		{
			List<object> billlist = new List<object>();
			List<Bill> res = new List<Bill>();
			object temp;

			DocumentReference docref = DB.Collection("Bill").Document(getEmail(address));
			DocumentSnapshot snap = docref.GetSnapshotAsync().Result;
			

			if (snap.Exists)
			{
				Dictionary<string, object> dic = snap.ToDictionary();
				dic.TryGetValue("money", out temp);
				paypermonth = int.Parse(temp.ToString());
				dic.TryGetValue("list", out temp);

				billlist = (List<object>) temp;

				if (billlist.Count == 0)
					return null;

				foreach (Dictionary<string, object> item in billlist)
				{
					item.TryGetValue("month", out object month);
					item.TryGetValue("pay", out object pay);
					Bill bill = new Bill(int.Parse(month.ToString()), int.Parse(pay.ToString()));

					res.Add(bill);
				}

				return res;
			}
			else
			{
				paypermonth = -1;
				return null;
			}
		}

		public void UpdateBillList(List<Bill> bills, string address)
		{

			DocumentReference docref = DB.Collection("Bill").Document(getEmail(address));
			DocumentSnapshot snap = docref.GetSnapshotAsync().Result;

			if (snap.Exists)
			{
				Dictionary<string, object> dict = new Dictionary<string, object>()
				{
					{"list", FieldValue.Delete }
				};
				snap.Reference.UpdateAsync(dict);

				foreach (Bill bill in bills.ToArray())
					Console.WriteLine(bill.month.ToString() + bill.pay);

				snap.Reference.UpdateAsync("list", FieldValue.ArrayUnion(bills.ToArray())).Wait();

			}
		}
		#endregion

		#region json

		private static string Request_Json(string url)
		{
			string result = string.Empty;
			try
			{
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
				using (var response = (HttpWebResponse)request.GetResponse())
				{
					using (Stream responseStream = response.GetResponseStream())
					{
						using (StreamReader stream = new StreamReader(responseStream, Encoding.UTF8))
						{
							result = stream.ReadToEnd();
						}
					}
				}
			}
			catch (Exception e)
			{
				Console.WriteLine(e.Message);
			}
			return result;
		}


		/*========== json parsing example =============

		private void JsonParser(String json)
		{
			JObject obj = JObject.Parse(json);
			JArray array = JArray.Parse(obj["d"].ToString());
			string result = null;

			foreach (JObject itemObj in array)
			{
				result += " ID : " + itemObj["Id"].ToString();
				result += " --- ";
				result += " Name : " + itemObj["Name"].ToString();
				result += "\r\n";
			}
		}
		*/

		public Image GetUrlImage(string url)
		{
			using (WebClient client = new WebClient())
			{
				byte[] imgArray;
				imgArray = client.DownloadData(url);

				using (MemoryStream memstr = new MemoryStream(imgArray))
				{
					Image img = Image.FromStream(memstr);
					return img;
				}
			}
		}

		#endregion
	}
}