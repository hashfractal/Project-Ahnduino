using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.IO;
using Google.Cloud.Firestore;
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

		public void CreateUser(string address)
        {
			/*
			 * 이메일받아옴
			 * 컬렉션 생성 함수 호출
			 * 
			 */
        }

		void Add_Document_with_AutoID()
		{
			CollectionReference coll = DB.Collection("test");
			Dictionary<string, object> data1 = new Dictionary<string, object>()
			{
				{"FirestName", "Kim" },
				{"LastName","Jinwon" },
				{"PhoneNumber", "010-1234-5678" }
			};
			coll.AddAsync(data1);
		}

		void Add_Document_with_CustomID()
		{
			DocumentReference DOC = DB.Collection("test").Document("myDoc");
			Dictionary<string, object> data1 = new Dictionary<string, object>()
			{
				{"FirestName", "Kim" },
				{"LastName","Jinwon" },
				{"PhoneNumber", "010-1234-5789" }
			};
			DOC.SetAsync(data1);
		}

		public string getEmail(string address)
		{
			CollectionReference colref = DB.Collection("User");
			Query query = colref.WhereEqualTo("주소", address);
			QuerySnapshot qusnap = query.GetSnapshotAsync().Result;
			DocumentSnapshot docsnap = qusnap[0];

			return docsnap.Id;
		}

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
			CollectionReference docref = DB.Collection("Bill");
			Query query = docref.WhereEqualTo("address", address);
			QuerySnapshot querySnapshot = query.GetSnapshotAsync().Result;
			DocumentSnapshot snap = null;
			foreach (DocumentSnapshot documentSnapshot in querySnapshot.Documents)
			{
				snap = documentSnapshot;
			}

			List<object> billlist = new List<object>();
			List<Bill> res = new List<Bill>();
			object temp;
			if (snap.Exists)
			{
				Dictionary<string, object> dic = snap.ToDictionary();
				dic.TryGetValue("money", out temp);
				paypermonth = int.Parse(temp.ToString());
				dic.TryGetValue("list", out temp);
				billlist = (List<object>) temp;

				foreach (Dictionary<string, object> item in billlist)
				{
					item.TryGetValue("date", out object date);
					item.TryGetValue("pay", out object pay);

					Bill bill = new Bill(date.ToString(), (bool)pay);

					res.Add(bill);
				}

				res.Sort((x, y) =>
				{
					return x.date.CompareTo(y.date);
				});

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
			CollectionReference docref = DB.Collection("Bill");
			Query query = docref.WhereEqualTo("address", address);
			QuerySnapshot querySnapshot = query.GetSnapshotAsync().Result;
			DocumentSnapshot snap = null;

			foreach (DocumentSnapshot documentSnapshot in querySnapshot.Documents)
			{
				snap = documentSnapshot;
			}

			if (snap.Exists)
			{
				Dictionary<string, object> dict = new Dictionary<string, object>()
				{
					{"list", FieldValue.Delete }
				};
				snap.Reference.UpdateAsync(dict);

				foreach (Bill bill in bills.ToArray())
					Console.WriteLine(bill.date + bill.pay);

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

		public static string Getimage(string filename)
		{
			JObject obj = JObject.Parse(
				Request_Json("https://firebasestorage.googleapis.com/v0/b/ahnduino.appspot.com/o/Bill%2F" + filename + ".png"));

			string link = "https://firebasestorage.googleapis.com/v0/b/ahnduino.appspot.com/o/Bill%2F" + filename
				+ ".png?alt=media&token=" + obj["downloadTokens"].ToString();
			return link;
		}

		#endregion
	}
}