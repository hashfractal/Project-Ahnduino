using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.IO;
using System.Security.Cryptography;
using Google.Cloud.Firestore;
using System.Drawing;
using Newtonsoft.Json.Linq;
using System.Text.RegularExpressions;
using Ahnduino.Lib.Object;

#pragma warning disable SYSLIB0022 // 형식 또는 멤버는 사용되지 않습니다.

namespace Ahnduino.Lib
{
	public static class Firebase
	{
		static FirestoreDb? DB;

		public static FirestoreDb GetDb { get { return DB!; } }

		static Firebase()
		{
			string path = "ahnduino-firebase-adminsdk-ddl6q-daf19142ac.json";
			System.Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", path);

			DB = FirestoreDb.Create("ahnduino");
		}

		public static void CreateUser(string email)
		{
			/*
			 * 이메일받아옴
			 * 컬렉션 생성 함수 호출
			 * 
			 */
		}

		public static string getEmail(string address)
		{
			CollectionReference colref = DB!.Collection("User");
			Query query = colref.WhereEqualTo("주소", address);
			QuerySnapshot qusnap = query.GetSnapshotAsync().Result;
			DocumentSnapshot docsnap = qusnap[0];

			return docsnap.Id;
		}

		public static string GetAddress(string email)
		{
			CollectionReference cref = DB!.Collection("User");
			Query query = cref.WhereEqualTo("메일", email);
			QuerySnapshot qsnap = query.GetSnapshotAsync().Result;
			DocumentSnapshot dsnap = qsnap[0];

			Dictionary<string, object> dic = dsnap.ToDictionary();

			dic.TryGetValue("주소", out object? temp);

			return temp!.ToString()!;
		}

		#region Auth

		public static bool IsValidEmail(string email)
		{
			return Regex.IsMatch(email, @"[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?");
		}

		public static bool IsValidPhone(string phone)
		{
			return Regex.IsMatch(phone, @"010-[0-9]{4}-[0-9]{4}$");
		}

		public static string[] FBValidation(string email, string password, string repassword, string name, string phone)
		{
			string[]? res = new string[5];

			res[0] = "";
			res[1] = "";
			res[2] = "";
			res[3] = "";
			res[4] = "";

			if (!IsValidEmail(email) || FindId(email))
				res[0] = "사용할 수 없는 이메일 입니다";
			if (password == "" || password == "사용할 수 없는 비밀번호 입니다")
				res[1] = "사용할 수 없는 비밀번호 입니다";
			if (password != repassword || repassword == "")
				res[2] = "재확인 비밀번호가 틀립니다";
			if (name == "" || name == "사용할 수 없는 이름 입니다")
				res[3] = "사용할 수 없는 이름 입니다";
			if (!IsValidPhone(phone))
				res[4] = "사용할 수 없는 전화번호 입니다";

			return res!;
		}

		public static bool Login(string email, string password)
		{
			Query qref = DB!.Collection("Manager").WhereEqualTo("Email", email).WhereEqualTo("Password", EncryptString(password, "flawless ahnduino"));
			QuerySnapshot snap = qref.GetSnapshotAsync().Result;

			foreach (DocumentSnapshot docsnap in snap)
			{
				if (docsnap.Exists)
				{
					return true;
				}
			}
			return false;
		}

		public static void Register(string email, string password, string repassword, string name, string phone)
		{
			if (email == "" || password == "" || repassword == "" || name == "" || phone == "") //공백이 입력될 경우
			{
				/*MessageBox.Show("아이디 또는 비밀번호에 공백이 있습니다.");*/
				return;
			}
			JoinManagement(email, password, name, phone);
		}

		private static void JoinManagement(string email, string password, string name, string phone)
		{
			bool idCheck = FindId(email);
			if (idCheck) { } //id가 이미 있으므로 회원가입 X
			else if (!idCheck) //id가 없으므로 회원가입 O
			{
				Join(email, password, name, phone);
			}
		}

		static void Join(string email, string password, string name, string phone)
		{
			DocumentReference DOC = DB!.Collection("Manager").Document(email);
			Dictionary<string, object> temp = new Dictionary<string, object>()
			{
				{"Email", email },
				{"Password", EncryptString(password,"flawless ahnduino") },
				{"Name", name },
				{"Phone", phone }
			};
			DOC.SetAsync(temp);
		}

		public static bool FindId(string email)
		{
			Query qref = DB!.Collection("Manager").WhereEqualTo("Email", email);
			QuerySnapshot snap = qref.GetSnapshotAsync().Result;

			foreach (DocumentSnapshot docsnap in snap)
			{
				if (docsnap.Exists)
				{
					return true;
				}
			}
			return false;
		}

		public static string ResetEmail(string email)
		{
			var characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
			var Charsarr = new char[8];
			var random = new Random();

			for (int i = 0; i < Charsarr.Length; i++)
			{
				Charsarr[i] = characters[random.Next(characters.Length)];
			}

			string resultString = new string(Charsarr);

			DocumentReference DOC = DB!.Collection("Manager").Document(email);
			Dictionary<string, object> temp = new Dictionary<string, object>()
			{
				{"Password", EncryptString(resultString,"flawless ahnduino") }
			};
			DOC.UpdateAsync(temp);

			return resultString;
		}

		// 암호화 AES256
		private static string EncryptString(string InputText, string Password)
		{
			string EncryptedData = "";
			try
			{
				// Rihndael class를 선언하고, 초기화
				RijndaelManaged RijndaelCipher = new RijndaelManaged();

				// 입력받은 문자열을 바이트 배열로 변환
				byte[] PlainText = System.Text.Encoding.Unicode.GetBytes(InputText);

				// 딕셔너리 공격을 대비해서 키를 더 풀기 어렵게 만들기 위해서 
				// Salt를 사용한다.
				byte[] Salt = Encoding.ASCII.GetBytes(Password.Length.ToString());

				// PasswordDeriveBytes 클래스를 사용해서 SecretKey를 얻는다.
				PasswordDeriveBytes SecretKey = new PasswordDeriveBytes(Password, Salt);

				// Create a encryptor from the existing SecretKey bytes.
				// encryptor 객체를 SecretKey로부터 만든다.
				// Secret Key에는 32바이트
				// (Rijndael의 디폴트인 256bit가 바로 32바이트입니다)를 사용하고, 
				// Initialization Vector로 16바이트
				// (역시 디폴트인 128비트가 바로 16바이트입니다)를 사용한다.
				ICryptoTransform Encryptor = RijndaelCipher.CreateEncryptor(SecretKey.GetBytes(32), SecretKey.GetBytes(16));

				// 메모리스트림 객체를 선언,초기화 
				MemoryStream memoryStream = new MemoryStream();

				// CryptoStream객체를 암호화된 데이터를 쓰기 위한 용도로 선언
				CryptoStream cryptoStream = new CryptoStream(memoryStream, Encryptor, CryptoStreamMode.Write);

				// 암호화 프로세스가 진행된다.
				cryptoStream.Write(PlainText, 0, PlainText.Length);

				// 암호화 종료
				cryptoStream.FlushFinalBlock();

				// 암호화된 데이터를 바이트 배열로 담는다.
				byte[] CipherBytes = memoryStream.ToArray();

				// 스트림 해제
				memoryStream.Close();
				cryptoStream.Close();

				// 암호화된 데이터를 Base64 인코딩된 문자열로 변환한다.
				EncryptedData = Convert.ToBase64String(CipherBytes);
			}
			catch { }
			// 최종 결과를 리턴
			return EncryptedData;
		}

		// 복호화 AES256
		private static string DecryptString(string InputText, string Password)
		{
			string DecryptedData = "";   // 리턴값
			try
			{
				RijndaelManaged RijndaelCipher = new RijndaelManaged();

				byte[] EncryptedData = Convert.FromBase64String(InputText);
				byte[] Salt = Encoding.ASCII.GetBytes(Password.Length.ToString());

				PasswordDeriveBytes SecretKey = new PasswordDeriveBytes(Password, Salt);

				// Decryptor 객체를 만든다.
				ICryptoTransform Decryptor = RijndaelCipher.CreateDecryptor(SecretKey.GetBytes(32), SecretKey.GetBytes(16));

				MemoryStream memoryStream = new MemoryStream(EncryptedData);

				// 데이터 읽기(복호화이므로) 용도로 cryptoStream객체를 선언, 초기화
				CryptoStream cryptoStream = new CryptoStream(memoryStream, Decryptor, CryptoStreamMode.Read);

				// 복호화된 데이터를 담을 바이트 배열을 선언한다.
				// 길이는 알 수 없지만, 일단 복호화되기 전의 데이터의 길이보다는
				// 길지 않을 것이기 때문에 그 길이로 선언한다.
				byte[] PlainText = new byte[EncryptedData.Length];

				// 복호화 시작
				int DecryptedCount = cryptoStream.Read(PlainText, 0, PlainText.Length);

				memoryStream.Close();
				cryptoStream.Close();

				// 복호화된 데이터를 문자열로 바꾼다.
				DecryptedData = Encoding.Unicode.GetString(PlainText, 0, DecryptedCount);

			}
			catch { }
			// 최종 결과 리턴
			return DecryptedData;
		}
		#endregion

		#region Request
		public static void GetRequestUserList(ObservableCollection<string> res)
		{
			Query query = DB!.Collection("ResponsAndReQuest").WhereEqualTo("isdone", false);

			FirestoreChangeListener listener = query.Listen(snapshot =>
			{
				DispatcherService.Invoke(() =>
				{
					res.Clear();
					foreach (DocumentSnapshot documentSnapshot in snapshot.Documents)
					{
						res.Add(documentSnapshot.Id);
					}
				});
			} );
		}

		public static void GetDateList(string? email, ObservableCollection<string> res)
		{
			if (email == null)
			{
				email = "null";
			}
			DocumentReference docRef = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request");
			FirestoreChangeListener listener = docRef.Listen(snapshot =>
			{
				DispatcherService.Invoke(() =>
				{
					res.Clear();
					IAsyncEnumerable<CollectionReference> subcollections = snapshot.Reference.ListCollectionsAsync();
					IAsyncEnumerator<CollectionReference> subcollectionsEnumerator = subcollections.GetAsyncEnumerator(default);
					while (subcollectionsEnumerator.MoveNextAsync().Result)
					{
						CollectionReference subcollectionRef = subcollectionsEnumerator.Current;
						if (subcollectionRef.Id.Length == 14)
						{
							res.Add(subcollectionRef.Id[..10]);
						}
					}
				});
			});

			if(email == "null")
			{
				listener.StopAsync();
			}
		}

		public static void GetRequestList(string? email, string? date, ObservableCollection<string> res)
		{
			if (date == null)
			{
				date = "null";
			}
			if(email == null)
			{
				email = "null";
			}

			Query query = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request").Collection(date + "예약 전");
			FirestoreChangeListener listener = query.Listen(snapshot =>
			{
				DispatcherService.Invoke(() =>
				{
					res.Clear();
					foreach (DocumentSnapshot documentSnapshot in snapshot.Documents)
					{
						res.Add(documentSnapshot.Id);
					}
				});
			});

			if (date == "null")
			{
				listener.StopAsync();
			}
		}

		public static Request? GetRequest (string? email, string? date, string? docid)
		{
			Query query = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request").Collection(date + "예약 전").WhereEqualTo("DocID", docid);
			QuerySnapshot qSnap = query.GetSnapshotAsync().Result;
			DocumentSnapshot dSnap = qSnap.Documents[0];

			if(dSnap.Exists)
			{
				Dictionary<string, object> dict = dSnap.ToDictionary();
				List<string> images = new();

				object temp;

				dSnap.TryGetValue("Date", out temp);
				string ddate = (string)temp;
				dSnap.TryGetValue("DocID", out temp);
				string docID = (string)temp;
				dSnap.TryGetValue("Text", out temp);
				string text = (string)temp;
				dSnap.TryGetValue("Time", out temp);
				Timestamp time = (Timestamp)temp;
				dSnap.TryGetValue("Title", out temp);
				string title = (string)temp;
				dSnap.TryGetValue("UID", out temp);
				string uid = (string)temp;
				dSnap.TryGetValue("isreserv", out temp);
				bool isreserve = (bool)temp;
				dSnap.TryGetValue("reserv", out temp);
				string reserve = (string)temp;
				dSnap.TryGetValue("sovled", out temp);
				bool solved = Convert.ToBoolean((string)temp);
				dSnap.TryGetValue("userName", out temp);
				string userName = (string)temp;

				int i = 0;
				while (dSnap.TryGetValue("image" + i, out temp))
				{
					images.Add((string)temp);
					i++;
				}

				Request res = new Request(ddate, docID, text, time, title, uid, isreserve, reserve, solved, userName, images);

				return res;
			}
			return null;
		}

		public static void UpdateRequest (string? email, string? date, string? docid, Request request, string UID)
		{
			Query query;
			QuerySnapshot qSnap;
			DocumentSnapshot dSnap;
			//예약 업데이트

			DocumentReference dRef = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request").Collection(date + "예약").Document(docid);
			
			Dictionary<string, object> dic = new Dictionary<string, object>()
			{
				{"Date", request.Date!},
				{"DocID", request.DocID!},
				{"Text", request.Text!},
				{"Time", request.Time!},
				{"Title", request.Title!},
				{"UID", request.UID!},
				{"isreserv", request.Isreserve!},
				{"reserv", request.Reserve!},
				{"solved", request.Solved!},
				{"userName", request.UserName!},
			};

			int n = 0;
			foreach(string i in request.Images!)
			{
				dic.Add("image" + n, i);
				n++;
			}

			dRef.SetAsync(dic);

			//현장직 대기
			dRef = DB!.Collection("MangerScagul").Document(UID).Collection("scaul").Document("scaul").Collection(request.Reserve + "수리예정").Document(request.DocID);
			dRef.SetAsync(dic);

			//예약전 삭제
			query = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request").Collection(date + "예약 전").WhereEqualTo("DocID", docid);
			qSnap = query.GetSnapshotAsync().Result;
			dSnap = qSnap.Documents[0];
			dRef = dSnap.Reference;
			dRef.DeleteAsync().Wait();


			//예약전 카운트
			query = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request").Collection(date + "예약 전");
			dRef = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request");
			Dictionary<string, object> updates = new Dictionary<string, object>
			{
				{ date! + "예약 전", query.GetSnapshotAsync().Result.Count }
			};
			dRef.UpdateAsync(updates).Wait();

			//예약 카운트
			query = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request").Collection(date + "예약");
			dRef = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request");
			Dictionary<string, object> update = new Dictionary<string, object>
			{
				{ date! + "예약", query.GetSnapshotAsync().Result.Count }
			};
			dRef.UpdateAsync(update).Wait();

			//isdone처리
			bool isdone = true;
			dSnap = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request").GetSnapshotAsync().Result;
			IAsyncEnumerable<CollectionReference> subcollections = dSnap.Reference.ListCollectionsAsync();
			IAsyncEnumerator<CollectionReference> subcollectionsEnumerator = subcollections.GetAsyncEnumerator(default);
			while (subcollectionsEnumerator.MoveNextAsync().Result)
			{
				CollectionReference subcollectionRef = subcollectionsEnumerator.Current;
				if (subcollectionRef.Id.Length == 14)
				{
					isdone = false;
				}
			}

			dRef = DB!.Collection("ResponsAndReQuest").Document(email);
			update = new Dictionary<string, object>
			{
				{ "isdone", isdone }
			};

			dRef.UpdateAsync(update).Wait();
		}
		#endregion

		#region Chat
		public static List<string> getChatList()
		{
			List<string> res = new List<string>();

			DocumentReference docref = DB!.Collection("chat").Document("chat");

			IAsyncEnumerable<CollectionReference> ascref = docref.ListCollectionsAsync();
			List<CollectionReference> colrefs = ascref.ToListAsync().Result;

			foreach (CollectionReference i in colrefs)
			{
				res.Add(i.Id);
			}
			return res;
		}
		#endregion

		#region Bill
		public static void createnewbill(string address)
		{
			/*
			 * getemail 로 이메일 받아옴
			 * Bill 컬렉션에 이메일 문서생성
			 * 문서 작성
			 * 
			 */
		}
		/*
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

				billlist = (List<object>)temp;

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
		*/
		#endregion

		#region json
		/*
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
		*/

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
		/*
		public  GetUrlImage(string url)
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
		*/
		#endregion
	}
}
