using Ahnduino.Lib.Object;
using Firebase.Storage;
using Google.Cloud.Firestore;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Media.Imaging;

#pragma warning disable SYSLIB0022 // 형식 또는 멤버는 사용되지 않습니다.

namespace Ahnduino.Lib
{
	public static class Fbad
	{
		static FirestoreDb? DB;

		public static FirestoreDb GetDb { get { return DB!; } }

		static Fbad()
		{
			string path = "ahnduino-firebase-adminsdk-ddl6q-daf19142ac.json";
			System.Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", path);

			DB = FirestoreDb.Create("ahnduino");
		}

		public static string getEmail(string fulladdress)
		{
			DocumentReference dRef = DB!.Collection("Building").Document(fulladdress);
			DocumentSnapshot dSnap = dRef.GetSnapshotAsync().Result;
			dSnap.TryGetValue("인증번호", out string temp);
			Query query = DB!.Collection("User").WhereEqualTo("인증번호", temp);
			QuerySnapshot qSnap = query.GetSnapshotAsync().Result;

			return qSnap.Documents[0].Id;
		}

		public static string GetAddress(string email)
		{
			CollectionReference cref = DB!.Collection("User");
			Query query = cref.WhereEqualTo("메일", email);
			QuerySnapshot qsnap = query.GetSnapshotAsync().Result;
			DocumentSnapshot dsnap = qsnap[0];

			Dictionary<string, object> dic = dsnap.ToDictionary();

			dic.TryGetValue("주소", out object? temp);
			dic.TryGetValue("건물명", out object? temp2);

			return temp!.ToString()! + "(" + temp2!.ToString() + ")";
		}

		public static Image GetImageFromUri(string uri)
		{
			Image image = new Image();

			BitmapImage bitmap = new BitmapImage();
			bitmap.BeginInit();
			bitmap.UriSource = new Uri(@uri, UriKind.Absolute);
			bitmap.EndInit();

			image.Source = bitmap;

			return image;
		}

		#region Build
		public static string? AddressToSerialNo(string fulladdress)
		{
			DocumentReference dRef = DB!.Collection("Building").Document(fulladdress);
			DocumentSnapshot dSnap = dRef.GetSnapshotAsync().Result;

			Dictionary<string, object> dict = dSnap.ToDictionary();
			if (dict.TryGetValue("인증번호", out object? temp))
				return (string)temp;
			else
				return null;
		}

		public static string? SerialNoToAddress(string SerialNo)
		{
			Query query = DB!.Collection("Building").WhereEqualTo("인증번호", SerialNo);
			QuerySnapshot qSnap = query.GetSnapshotAsync().Result;
			return qSnap.Documents[0].Id;
		}

		public static string AddressToEmail(string fulladdress)
		{
			DocumentReference dRef = DB!.Collection("Building").Document(fulladdress);
			DocumentSnapshot dSnap = dRef.GetSnapshotAsync().Result;
			dSnap.TryGetValue("인증번호", out object temp);

			Query query = DB!.Collection("User").WhereEqualTo("인증번호", temp);
			QuerySnapshot qSnap = query.GetSnapshotAsync().Result;
			dSnap = qSnap.Documents[0];

			return dSnap.Id;
		}

		public static List<Build> GetBuildListFormAddress(string address)
		{
			List<Build> builds = new List<Build>();
			Query query = DB!.Collection("Building").WhereEqualTo("주소", address);
			QuerySnapshot qSnap = query.GetSnapshotAsync().Result;
			foreach(DocumentSnapshot i in qSnap.Documents)
			{
				builds.Add(i.ConvertTo<Build>());
			}

			return builds;
		}

		public static Build GetBuildFormFullAddress(string fulladdress)
		{
			DocumentReference dRef = DB!.Collection("Building").Document(fulladdress);
			DocumentSnapshot dSnap = dRef.GetSnapshotAsync().Result;

			return dSnap.ConvertTo<Build>();
		}

		public static Build GetBuildFormID(string ID)
		{
			try
			{
				Query query = DB!.Collection("Building").WhereEqualTo("인증번호", ID);
				QuerySnapshot qSnap = query.GetSnapshotAsync().Result;

				return qSnap.Documents[0].ConvertTo<Build>();
			}
			catch (Exception)
			{

				throw;
			}
			
		}

		public static int? GetPayFromAddress(string fulladdress)
		{
			DocumentReference dRef = DB!.Collection("Building").Document(fulladdress);
			DocumentSnapshot dSnap = dRef.GetSnapshotAsync().Result;

			Dictionary<string, object> dict = dSnap.ToDictionary();
			if (dict.TryGetValue("관리비", out object? temp))
				return Convert.ToInt32(temp);
			else
				return null;
		}

		public static void AddBuild(string address, string buildname, string buildid, int pay, int unpay)
		{
			DocumentReference dRef = DB!.Collection("Building").Document(address + "(" + buildname + ")");
			Dictionary<string, object> dict = new Dictionary<string, object>
			{
				{ "주소", address },
				{ "건물명", buildname },
				{ "인증번호", buildid },
				{ "관리비", pay },
				{ "연체료", unpay },
				{ "Used", false },
				{ "미납", false },
				{ "수리비", false },

			};

			dRef.SetAsync(dict, SetOptions.MergeAll);
		}

		public static void DeleteBuild(string fulladdress)
		{
			DocumentReference dRef = DB!.Collection("Building").Document(fulladdress);
			dRef.DeleteAsync();
		}

		public static string validationBuild(string address, string buildname, string buildid)
		{
			string res = "";
			DocumentReference dRef = DB!.Collection("Building").Document(address + "(" + buildname + ")");
			DocumentSnapshot dSnap = dRef.GetSnapshotAsync().Result;
			Query query = DB!.Collection("Building").WhereEqualTo("인증번호", buildid);
			QuerySnapshot qSanp = query.GetSnapshotAsync().Result;

			if (dSnap.Exists)
				res += "이미 등록된 주소입니다\r\n";
			if (qSanp.Count > 0)
				res += "이미 등록된 건물 인증번호 입니다\r\n";

			return res;
		}
		#endregion

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
		static void GetTotalRequestList(ObservableCollection<Request> requestlist, QuerySnapshot request, QuerySnapshot roomout)
		{
			Task.Factory.StartNew(() =>
			{
				DispatcherService.Invoke(() =>
				{
					Request temp = new Request();
					requestlist.Clear();

					foreach (DocumentSnapshot documentSnapshot in request.Documents)
					{
						DocumentReference dRef = documentSnapshot.Reference;
						IAsyncEnumerable<CollectionReference> clist = dRef.Collection("Request").Document("Request").ListCollectionsAsync();
						IAsyncEnumerator<CollectionReference> subcollectionsEnumerator = clist.GetAsyncEnumerator(default);

						while (subcollectionsEnumerator.MoveNextAsync().Result)
						{
							CollectionReference i = subcollectionsEnumerator.Current;
							if (i.Id.Length == 14)
							{
								QuerySnapshot qsnp = i.GetSnapshotAsync().Result;
								foreach (DocumentSnapshot ds in qsnp.Documents)
								{
									temp = ds.ConvertTo<Request>();
									temp.Images = new List<string>();
									Dictionary<string, object> dict = ds.ToDictionary();
									int n = 0;

									while (dict.TryGetValue("image" + n, out object? temp2))
									{
										temp.Images.Add((string)temp2);
										n++;
									}
									DispatcherService.Invoke(() =>
									{
										requestlist.Add(temp);
									});
								}
							}
						}
					}

					foreach (DocumentSnapshot i in roomout.Documents)
					{
						i.TryGetValue("퇴실신청일", out Timestamp timestamp);
						DateTime dt = timestamp.ToDateTime();
						dt = dt.AddHours(+9);
						Request request = new Request();
						request.Date = string.Format("{0:yyyy-MM-dd}", dt);
						request.DocID = i.Id;
						request.Text = "퇴실 신청";
						request.Time = timestamp;
						request.Title = "퇴실 신청";
						request.UID = i.Id;
						request.Reserve = "";
						request.solved = false;
						request.userName = i.Id;
						request.hopeTime0 = string.Format("{0:yy}/{1:MM}/{2:dd}{3:tt hh 시 mm 분}", dt, dt, dt, dt);

						requestlist.Add(request);
					}
				});
			});
		}
		public static void GetRequestList(ObservableCollection<Request> requestlist)
		{
			Query query = DB!.Collection("ResponsAndReQuest").WhereEqualTo("isdone", false);
			Query query2 = DB!.Collection("RoomOut");

			FirestoreChangeListener listener = query.Listen(snapshot =>
			{
				QuerySnapshot qSnap = query2.GetSnapshotAsync().Result;
				GetTotalRequestList(requestlist, snapshot, qSnap);
			});

			FirestoreChangeListener listener2 = query2.Listen(snapshot =>
			{
				QuerySnapshot qSnap = query.GetSnapshotAsync().Result;
				GetTotalRequestList(requestlist, qSnap, snapshot);
			});
		}

		public static void GetRequestListRef(ObservableCollection<Request> requestlist)
		{
			Query query = DB!.Collection("ResponsAndReQuest").WhereEqualTo("isdone", false);

			FirestoreChangeListener listener = query.Listen(snapshot =>
			{
				DispatcherService.Invoke(() =>
				{
					Request temp = new Request();
					requestlist.Clear();
					Thread trd = new Thread(() =>
					{
						foreach (DocumentSnapshot documentSnapshot in snapshot.Documents)
						{
							DocumentReference dRef = documentSnapshot.Reference;
							IAsyncEnumerable<CollectionReference> clist = dRef.Collection("Request").Document("Request").ListCollectionsAsync();
							IAsyncEnumerator<CollectionReference> subcollectionsEnumerator = clist.GetAsyncEnumerator(default);

							while (subcollectionsEnumerator.MoveNextAsync().Result)
							{
								CollectionReference i = subcollectionsEnumerator.Current;
								if (i.Id.Length == 14)
								{
									QuerySnapshot qsnp = i.GetSnapshotAsync().Result;
									foreach (DocumentSnapshot ds in qsnp.Documents)
									{
										temp = ds.ConvertTo<Request>();
										temp.Images = new List<string>();
										Dictionary<string, object> dict = ds.ToDictionary();
										int n = 0;

										while (dict.TryGetValue("image" + n, out object? temp2))
										{
											temp.Images.Add((string)temp2);
											n++;
										}
										DispatcherService.Invoke(() =>
										{
											requestlist.Add(temp);
										});
										
									}
								}
							}
						}
					});
					
					trd.Start();
				});
			});
		}

		public static void UpdateRequest (string? email, string? date, string? docid, Request request, string UID, DateTime reservedtime)
		{
			Query query;
			QuerySnapshot qSnap;
			DocumentSnapshot dSnap;

			//퇴실 신청일 경우 퇴실신청 삭제
			if(request.Text == "퇴실 신청" && request.Title =="퇴실 신청")
			{
				DocumentReference dr = DB!.Collection("RoomOut").Document(email);
				dr.DeleteAsync();
			}

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
				{"solved", request.solved!},
				{"userName", request.userName!},
			};

			int n = 0;
			if (request.Images != null)
			{
				foreach (string i in request.Images)
				{
					dic.Add("image" + n, i);
					n++;
				}
			}
			

			dRef.SetAsync(dic, SetOptions.MergeAll);

			//현장직 문서 추가
			dRef = DB!.Collection("User").Document(request.UID);
			dSnap = dRef.GetSnapshotAsync().Result;

			dSnap.TryGetValue("주소", out string address);
			dSnap.TryGetValue("건물명", out string buildname);
			Dictionary<string, object> worker = new Dictionary<string, object>
			{
				{ "건물명", address},
				{ "주소",  buildname},
				{ "reservTime", Timestamp.FromDateTime(reservedtime.ToUniversalTime())}
			};

			dRef = DB!.Collection("MangerScagul").Document(UID).Collection("scaul").Document("scaul").Collection(string.Format("{0:yyyy-MM-dd}", reservedtime) + " 스케쥴").Document(request.DocID);
			dRef.SetAsync(dic, SetOptions.MergeAll).Wait();
			dRef.SetAsync(worker, SetOptions.MergeAll).Wait();

			//현장직 예약 카운트
			query = DB!.Collection("MangerScagul").Document(UID).Collection("scaul").Document("scaul").Collection(string.Format("{0:yyyy-MM-dd}", reservedtime) + " 스케쥴");
			dRef = DB!.Collection("MangerScagul").Document(UID).Collection("scaul").Document("scaul");
			int test = query.GetSnapshotAsync().Result.Count;
			Dictionary<string, object> update = new Dictionary<string, object>
			{
				{ string.Format("{0:yyyy-MM-dd}", reservedtime) + " 스케쥴", query.GetSnapshotAsync().Result.Count != 0 ? query.GetSnapshotAsync().Result.Count : FieldValue.Delete }
			};
			dRef.SetAsync(update, SetOptions.MergeAll).Wait();

			//All 카운트
			dRef = DB!.Collection("MangerScagul").Document(UID).Collection("scaul").Document("scaul");
			dSnap = DB!.Collection("MangerScagul").Document(UID).Collection("scaul").Document("scaul").GetSnapshotAsync().Result;
			dSnap.TryGetValue<int>("All", out int all);

			Dictionary<string, object> updateall = new Dictionary<string, object>
			{
				{ "All", ++all > 0 ? all : FieldValue.Delete }
			};
			dRef.SetAsync(updateall, SetOptions.MergeAll).Wait();

			//예약전 삭제
			query = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request").Collection(date + "예약 전").WhereEqualTo("DocID", docid);
			qSnap = query.GetSnapshotAsync().Result;
			if(qSnap.Count > 0)
			{
				dSnap = qSnap.Documents[0];
				dRef = dSnap.Reference;
				dRef.DeleteAsync().Wait();
			}

			//예약전 카운트
			query = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request").Collection(date + "예약 전");
			dRef = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request");
			Dictionary<string, object> updates = new Dictionary<string, object>
			{
				{ date! + "예약 전", query.GetSnapshotAsync().Result.Count > 0 ? query.GetSnapshotAsync().Result.Count : FieldValue.Delete }
			};
			dRef.SetAsync(updates, SetOptions.MergeAll).Wait();

			//예약 카운트
			query = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request").Collection(date + "예약");
			dRef = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request");
			update = new Dictionary<string, object>
			{
				{ date! + "예약", query.GetSnapshotAsync().Result.Count > 0 ? query.GetSnapshotAsync().Result.Count : FieldValue.Delete }
			};
			dRef.SetAsync(update, SetOptions.MergeAll).Wait();

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

			dRef.SetAsync(update, SetOptions.MergeAll).Wait();
		}

		public static void RemoveRequest(string? email, string? date, string? docid, Request request, string UID)
		{
			Query query;
			DocumentSnapshot dSnap;

			//예약전 삭제
			DocumentReference dRef = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request").Collection(date + "예약 전").Document(docid);

			dRef.DeleteAsync().Wait();

			//예약전 카운트
			query = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request").Collection(date + "예약 전");
			dRef = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request");
			Dictionary<string, object> updates = new Dictionary<string, object>
			{
				{ date! + "예약 전", query.GetSnapshotAsync().Result.Count > 0 ? query.GetSnapshotAsync().Result.Count : FieldValue.Delete }
			};
			dRef.SetAsync(updates, SetOptions.MergeAll).Wait();

			//예약 카운트
			query = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request").Collection(date + "예약");
			dRef = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request");
			Dictionary<string, object> update = new Dictionary<string, object>
			{
				{ date! + "예약", query.GetSnapshotAsync().Result.Count > 0 ? query.GetSnapshotAsync().Result.Count : FieldValue.Delete }
			};
			dRef.SetAsync(update, SetOptions.MergeAll).Wait();

			//All 카운트
			dRef = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request");
			dSnap = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request").GetSnapshotAsync().Result;
			dSnap.TryGetValue<int>("All", out int all);

			Dictionary<string, object> updateall = new Dictionary<string, object>
			{
				{ "All", --all > 0 ? all : FieldValue.Delete }
			};
			dRef.SetAsync(updateall, SetOptions.MergeAll).Wait();

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

			dRef.SetAsync(update, SetOptions.MergeAll).Wait();
		}

		public static void SetWorkerComboBox(ComboBox Region, ComboBox Gu, ComboBox Dong)
		{

			List<string> regionlist = new List<string>();
			List<string> gulist = new List<string>();
			List<string> donglist = new List<string>();

			DocumentReference dRef = DB!.Collection("WorkerAdress").Document("address");
			DocumentSnapshot dSnap = dRef.GetSnapshotAsync().Result;

			Dictionary<string, object> dict = dSnap.ToDictionary();
			foreach (KeyValuePair<string, object> i in dict)
			{
				string[] strs = i.Key.Split(' ');

				
					if (strs.Count() > 0)
					{
						if (regionlist.Find(x => x == strs[0]) == null)
							regionlist.Add(strs[0]);
					}
					
					if (strs.Count() > 1)
					{
						if (gulist.Find(x => x == strs[1]) == null)
							gulist.Add(strs[1]);
					}

				
					if (strs.Count() > 2)
					{
						if (donglist.Find(x => x == strs[2]) == null)
							donglist.Add(strs[2]);
					}
			}

			Region.ItemsSource = regionlist;
			Gu.ItemsSource = gulist;
			Dong.ItemsSource = donglist;
		}

		public static List<string> SetWorker(string region, string gu, string dong)
		{
			List<string> res = new List<string>();
			Query query = DB!.Collection("Worker").WhereEqualTo("근무지", region + " " + gu + " " + dong);
			QuerySnapshot qSnap = query.GetSnapshotAsync().Result;

			foreach(DocumentSnapshot i in qSnap.Documents)
			{
				res.Add(i.Id);
			}

			return res;
		}
		#endregion

		#region FixHold
		public static List<FixHold> GetFixHoldList()
		{
			List<FixHold> res = new List<FixHold>();
			Query query = DB!.Collection("FixHold");
			QuerySnapshot qSnap = query.GetSnapshotAsync().Result;

			foreach(DocumentSnapshot i in qSnap.Documents)
			{
				Query qry = DB!.Collection("FixHold").Document(i.Id).Collection("FixHold");
				QuerySnapshot qsp = qry.GetSnapshotAsync().Result;

				foreach(DocumentSnapshot j in qsp.Documents)
				{
					FixHold fixHold = j.ConvertTo<FixHold>();
					fixHold.worker = i.Id;

					res.Add(fixHold);
				}
			}

			return res;
		}

		public static void RemoveFixHold(string workeremail, string docid)
		{
			DocumentReference dRef = DB!.Collection("FixHold").Document(workeremail).Collection("FixHold").Document(docid);
			dRef.DeleteAsync().Wait();
		}
		#endregion

		#region Chat
		public static void FirstGetChatList(string email, ObservableCollection<Chat> chatlist)
		{
			chatlist.Clear();
			CollectionReference collectionRef = DB!.Collection("chat").Document("chat").Collection(email);
			Query query = collectionRef.OrderByDescending("time").Limit(50);
			QuerySnapshot qSnap = query.GetSnapshotAsync().Result;
			foreach(DocumentSnapshot dSnap in qSnap.Documents)
			{
				Dictionary<string, object> dict = dSnap.ToDictionary();
				List<string> images = new();

				object temp;

				int i = 0;
				while (dSnap.TryGetValue("image" + i, out temp))
				{
					images.Add((string)temp);
					i++;
				}

				Chat res = dSnap.ConvertTo<Chat>();
				res.imagelist = images;

				res.trueimage = new List<Image>();
				foreach(string j in res.imagelist)
				{
					Image img = GetImageFromUri(j);
					img.Height = 200;
					img.Width = 200;
					res.trueimage!.Add(img);
				}

				res.address = GetAddress(email);

				chatlist.Insert(0, res);
			}
		}

		public static void GetChatList(string email, ObservableCollection<Chat> chatlist)
		{
			ObservableCollection<Chat> list = new ObservableCollection<Chat>();
			CollectionReference collectionRef = DB!.Collection("chat").Document("chat").Collection(email);
			Query query = collectionRef.WhereLessThan("time", chatlist.First().time) .OrderByDescending("time").Limit(50);
			QuerySnapshot qSnap = query.GetSnapshotAsync().Result;
			foreach (DocumentSnapshot dSnap in qSnap.Documents)
			{
				Dictionary<string, object> dict = dSnap.ToDictionary();
				List<string> images = new();

				object temp;

				int i = 0;
				while (dSnap.TryGetValue("image" + i, out temp))
				{
					images.Add((string)temp);
					i++;
				}

				Chat res = dSnap.ConvertTo<Chat>();
				res.imagelist = images;

				res.trueimage = new List<Image>();
				foreach (string j in res.imagelist)
				{
					Image img = GetImageFromUri(j);
					img.Height = 200;
					img.Width = 200;
					res.trueimage!.Add(img);
				}

				list.Add(res);
			}
			foreach(Chat i in list)
			{
				chatlist.Insert(0, i);
			}
		}

		public static void GetChat(string? email, ObservableCollection<Chat> chatlist, ScrollViewer scrollViewer)
		{
			if (email == null)
			{
				email = "null";
			}
			CollectionReference collectionRef = DB!.Collection("chat").Document("chat").Collection(email);
			Query query = collectionRef.OrderByDescending("time").Limit(1);
			FirestoreChangeListener listener = collectionRef.Listen(snapshot =>
			{
				DispatcherService.Invoke(() =>
				{
					QuerySnapshot qSnap = query.GetSnapshotAsync().Result;
					Chat chat = qSnap.Documents[0].ConvertTo<Chat>();

					List<string> images = new();

					object temp;

					int i = 0;
					while (qSnap.Documents[0].TryGetValue("image" + i, out temp))
					{
						images.Add((string)temp);
						i++;
					}

					chat.imagelist = images;

					chat.trueimage = new List<Image>();
					foreach (string j in chat.imagelist)
					{
						Image img = GetImageFromUri(j);
						img.Height = 200;
						img.Width = 200;
						chat.trueimage!.Add(img);
					}

					chat.address = GetAddress(email);

					chatlist.Add(chat);
					scrollViewer.ScrollToBottom();
				});
			});

			if (email == "null")
			{
				listener.StopAsync();
			}
		}

		public static void GetChatUserList(ObservableCollection<string> chatuserlist)
		{
			Query query = DB!.Collection("chat").Document("chat").Collection("needanswer");

			FirestoreChangeListener listener = query.Listen(snapshot =>
			{
				DispatcherService.Invoke(() =>
				{
					chatuserlist.Clear();
					foreach (DocumentSnapshot documentSnapshot in snapshot.Documents)
					{
						chatuserlist.Add(GetAddress(documentSnapshot.Id));
					}
				});
			});
		}

		public static async Task<string> UploadChatImg(string email, string path, string docid)
		{
			var stream = File.Open(@path, FileMode.Open);

			// Construct FirebaseStorage with path to where you want to upload the file and put it there
			var task = new FirebaseStorage("ahnduino.appspot.com")
			 .Child(email)
			 .Child("chat")
			 .Child(docid)
			 .Child(Path.GetFileName(path))
			 .PutAsync(stream);

			// Await the task to wait until upload is completed and get the download url
			var downloadUrl = await task;
			stream.Close();
			return downloadUrl;
		}

		public static void SendChat(string email,string uid, string text)
		{
			CollectionReference cRef = DB!.Collection("chat").Document("chat").Collection(email);
			Chat chat = new Chat();
			chat.chat = uid;
			chat.text = text;
			chat.time = Timestamp.FromDateTime(DateTime.UtcNow);
			chat.type = false;
			cRef.AddAsync(chat).Wait();
			answerdone(email);
		}

		public static void SendImg(string email, string uid, string[] Imagelist)
		{
			List<string> temp = new();
			DocumentReference dRef = DB!.Collection("chat").Document("chat").Collection(email).Document();
			Chat chat = new Chat();
			chat.chat = uid;
			chat.text = "";
			chat.time = Timestamp.FromDateTime(DateTime.UtcNow);
			chat.type = false;

			Dictionary<string, object> dict = new Dictionary<string, object>()
			{
				{"chat", chat.chat},
				{"text", chat.text},
				{"time", chat.time},
				{"type", chat.type},
			};

			int n = 0;
			foreach (string i in Imagelist)
			{
				Task task = new(() =>
				{
					dict.Add("image" + n, UploadChatImg(email, i, dRef.Id).Result);
					n++;
				});
				task.Start();
				task.Wait();
			}

			dRef.SetAsync(dict, SetOptions.MergeAll).Wait();
			answerdone(email);
		}

		public static void answerdone(string email)
		{
			DocumentReference dRef = DB!.Collection("chat").Document("chat").Collection("needanswer").Document(email);
			dRef.DeleteAsync();
		}
		#endregion

		#region Bill
		public static void GetBillList(string? email, ObservableCollection<Bill> billlist)
		{
			billlist.Clear();
			CollectionReference cRef = DB!.Collection("Bill").Document(email).Collection("Month");
			Query query = cRef.OrderBy("Nab");
			QuerySnapshot qSanp = query.GetSnapshotAsync().Result;
			foreach (DocumentSnapshot dSnap in qSanp.Documents)
			{
				billlist.Add(dSnap.ConvertTo<Bill>());
			}
		}

		public static void GetneedListbox(ListBox listBox)
		{
			Query query = DB!.Collection("Building").WhereEqualTo("Used", true);
			QuerySnapshot qSnap = query.GetSnapshotAsync().Result;
			foreach(DocumentSnapshot i in qSnap.Documents)
			{
				i.TryGetValue("미납", out bool isunpay);
				i.TryGetValue("수리비", out bool isfix);

				if(isunpay || isfix)
				{
					listBox.Items.Add(i.Id);
				}
			}
		}

		public static void AcceptPay(string? email, Bill bill)
		{
			Query query = DB!.Collection("Bill").Document(email).Collection("Month").WhereLessThanOrEqualTo("Nab", bill.Nab);
			QuerySnapshot qSanp = query.GetSnapshotAsync().Result;
			foreach(DocumentSnapshot dSnap in qSanp.Documents)
			{
				Dictionary<string, object> dict = new Dictionary<string, object>()
				{
					{ "Pay", true },
					{ "Ab", 1 },
				};
				dSnap.Reference.SetAsync(dict, SetOptions.MergeAll);
			}

			Dictionary<string, object> dict2 = new Dictionary<string, object>
			{
				{ "미납", false },
				{ "수리비", false },
			};

			DocumentReference dRef = DB!.Collection("Building").Document(GetAddress(email!));
			dRef.SetAsync(dict2, SetOptions.MergeAll);
			
		}

		public static void SetNewBill(string? email, Bill newbill)
		{
			Query query = DB!.Collection("Bill").Document(email).Collection("Month").OrderByDescending("Nab").Limit(1);
			QuerySnapshot qSanp = query.GetSnapshotAsync().Result;
			if(qSanp.Count > 0)
			{
				DocumentSnapshot dSnap = qSanp.Documents[0];
				Bill lastbill = dSnap.ConvertTo<Bill>();

				Timestamp timestamp = (Timestamp)lastbill.Nab!;
				DateTime dateTime = timestamp.ToDateTime();

				newbill.Ab = 2;
				newbill.Arrears = lastbill.Arrears;
				newbill.Money = lastbill.Money;
				newbill.Nab = Timestamp.FromDateTime(dateTime);
				newbill.Pay = false;
				newbill.Repair = 0;

				// defmoney pomoney totmoney 연산
				if (lastbill.Ab == 2)
				{
					newbill.Defmoney = lastbill.Pomoney;

				}
				else if (lastbill.Ab == 1)
				{
					newbill.Defmoney = 0;
				}
				newbill.Totmoney = newbill.Money + newbill.Repair + newbill.Defmoney;
				newbill.Pomoney = newbill.Totmoney + newbill.Arrears;
			}
			else
			{
				newbill.Ab = 2;
				newbill.Arrears = null;
				newbill.Defmoney = 0;
				newbill.Money = null;
				newbill.Nab = null;
				newbill.Pay = false;
				newbill.Pomoney = null;
				newbill.Repair = 0;
				newbill.Totmoney = null;
			}
		}

		public static void CreateBill(string? email, Bill newbill, int billlistcount)
		{
			if(billlistcount >= 12)
			{
				Query query = DB!.Collection("Bill").Document(email).Collection("Month").OrderBy("Nab").Limit(1);
				QuerySnapshot qSanp = query.GetSnapshotAsync().Result;
				DocumentSnapshot dSnap = qSanp.Documents[0];
				dSnap.Reference.DeleteAsync().Wait();
			}

			Timestamp temp = (Timestamp)newbill.Nab!;
			DateTime Month = temp.ToDateTime();
			DocumentReference dRef = DB!.Collection("Bill").Document(email).Collection("Month").Document((Month.Month - 1 == 0 ? 12 : Month.Month - 1) + "월");
			dRef.SetAsync(newbill, SetOptions.MergeAll);
		}

		public static void UpdateBIll()
		{
			CollectionReference cRef = DB!.Collection("Bill");
		}
		#endregion

		#region Board
		public static void GetBoardList(ObservableCollection<Board> boardlist)
		{
			boardlist.Clear(); 
			Query query = DB!.Collection("board").OrderByDescending("time");
			QuerySnapshot qSanp = query.GetSnapshotAsync().Result;
			foreach(DocumentSnapshot dSnap in qSanp.Documents)
			{
				List<string> images = new();
				Board board;
				object temp;

				board = dSnap.ConvertTo<Board>();

				int i = 0;
				while (dSnap.TryGetValue("image" + i, out temp))
				{
					images.Add((string)temp);
					i++;
				}
				board.imagelist = images;

				boardlist.Add(board);
			}
		}

		public static void SearchBoardList(string keyword, ObservableCollection<Board> boardlist)
		{
			boardlist.Clear();
			Query query = DB!.Collection("board").WhereGreaterThanOrEqualTo("title", keyword).WhereLessThanOrEqualTo("title", keyword + '\uf8ff');
			QuerySnapshot qSanp = query.GetSnapshotAsync().Result;
			foreach (DocumentSnapshot dSnap in qSanp.Documents)
			{
				List<string> images = new();
				Board board;
				object temp;

				board = dSnap.ConvertTo<Board>();

				int i = 0;
				while (dSnap.TryGetValue("image" + i, out temp))
				{
					images.Add((string)temp);
					i++;
				}
				board.imagelist = images;

				boardlist.Add(board);
			}
		}

		public static string CreateBoard(Board board)
		{
			if(board.DocID == null)
			{
				CollectionReference cRef = DB!.Collection("board");
				DocumentReference dRef = cRef.AddAsync(board).Result;
				board.DocID = dRef.Id;
				dRef.SetAsync(board, SetOptions.MergeAll).Wait();

				if(board.imagelist != null)
				{
					Dictionary<string, object> dict = new();
					int n = 0;
					foreach (string i in board!.imagelist!)
					{
						dict.Add("image" + n, i);
						n++;
					}
					dRef.SetAsync(dict, SetOptions.MergeAll).Wait();
				}
				return dRef.Id;
			}

			else
			{
				DocumentReference dRef = DB!.Collection("board").Document(board.DocID);
				dRef.SetAsync(board, SetOptions.MergeAll).Wait();

				if (board.imagelist != null)
				{
					Dictionary<string, object> dict = new();
					int n = 0;
					foreach (string i in board!.imagelist!)
					{
						dict.Add("image" + n, i);
						n++;
					}
					dRef.SetAsync(dict, SetOptions.MergeAll).Wait();
				}

				return dRef.Id;
			}
		}

		public static void DeleteBoard(Board board)
		{
			DocumentReference dRef = DB!.Collection("board").Document(board.DocID);
			dRef.DeleteAsync().Wait();
		}

		public static async Task<string> UploadBoardImg(string path, string docid)
		{
			var stream = File.Open(@path, FileMode.Open);

			// Construct FirebaseStorage with path to where you want to upload the file and put it there
			var task = new FirebaseStorage("ahnduino.appspot.com")
			 .Child("board")
			 .Child(docid)
			 .Child(Path.GetFileName(path))
			 .PutAsync(stream);

			// Await the task to wait until upload is completed and get the download url
			var downloadUrl = await task;
			stream.Close();
			return downloadUrl;
		}
		public static void BoardAddimage(Board board, string[] imglist, string docid)
		{
			if (board.imagelist == null)
				board.imagelist = new List<string>();
			foreach (string i in imglist)
			{
				int n = 0;
				Task task = new(() =>
				{
					board.imagelist.Add(UploadBoardImg(i, docid).Result);
					n++;
				});
				task.Start();
				task.Wait();
			}
		}
		#endregion

		#region Info
		public static void GetCheckInList(string email, ListBox checkinlistbox, ListBox checkoutlistbox)
		{
			CollectionReference cRef = DB!.Collection("CheckInCheckOut").Document(email).Collection("입실");
			QuerySnapshot qSnap = cRef.GetSnapshotAsync().Result;
			foreach (DocumentSnapshot i in qSnap.Documents)
			{
				checkinlistbox.Items.Add(i.ConvertTo<Room>());
			}

			cRef = DB!.Collection("CheckInCheckOut").Document(email).Collection("퇴실");
			qSnap = cRef.GetSnapshotAsync().Result;
			foreach(DocumentSnapshot i in qSnap.Documents)
			{
				checkoutlistbox.Items.Add(i.ConvertTo<Room>());
			}

		}

		public static void GetInfoRepairList(string email, ListBox requestlistbox)
		{
			DocumentReference dRef = DB!.Collection("ResponsAndReQuest").Document(email).Collection("Request").Document("Request");

			IAsyncEnumerable < CollectionReference > clist = dRef.ListCollectionsAsync();
			IAsyncEnumerator<CollectionReference> subcollectionsEnumerator = clist.GetAsyncEnumerator(default);
			while (subcollectionsEnumerator.MoveNextAsync().Result)
			{
				CollectionReference i = subcollectionsEnumerator.Current;
				QuerySnapshot qSnap = i.GetSnapshotAsync().Result;

				foreach(DocumentSnapshot dSnap in qSnap.Documents)
				{
					requestlistbox.Items.Add(dSnap.ConvertTo<Request>());
				}
			}
		}
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
