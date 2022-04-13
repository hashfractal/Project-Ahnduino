using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.IO;
using Google.Cloud.Firestore;
using Newtonsoft.Json.Linq;

namespace Ahnduino
{
	internal class FireBase
	{
		FirestoreDb DB;

		private void initialize()
		{
			string path = AppDomain.CurrentDomain.BaseDirectory + @"ahnduino-firebase-adminsdk-ddl6q-daf19142ac.json";
			Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", path);

			DB = FirestoreDb.Create("ahnduino");
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

		async List<bill> GetBillList(string uid)
		{
			DocumentReference docref = DB.Collection("Bill").Document(uid);
			DocumentSnapshot snap = await docref.GetSnapshotAsync();

			if (snap.Exists)
			{
				object temp;
				Dictionary<string, object> city = snap.ToDictionary();
				List<bill> billlist = new List<bill>();

				city.TryGetValue("list", out temp);
				billlist = (List<bill>)temp;

				return billlist;
			}
		}


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

		public static string Getimage(String filename)
		{
			JObject obj = JObject.Parse(
				Request_Json("https://firebasestorage.googleapis.com/v0/b/ahnduino.appspot.com/o/" + filename + ".png"));
			string link = null;

			link = "https://firebasestorage.googleapis.com/v0/b/ahnduino.appspot.com/o/" + filename
				+ ".png?alt=media&token=" + obj["downloadTokens"].ToString();
			return link;
		}

		#endregion
	}
}