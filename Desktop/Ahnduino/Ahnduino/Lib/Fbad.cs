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

		public static List<string> AddressToEmailList(string fulladdress)
		{
			List<string> res = new();
			DocumentReference dRef = DB!.Collection("Building").Document(fulladdress);
			DocumentSnapshot dSnap = dRef.GetSnapshotAsync().Result;
			dSnap.TryGetValue("인증번호", out object temp);

			Query query = DB!.Collection("User").WhereEqualTo("인증번호", temp);
			QuerySnapshot qSnap = query.GetSnapshotAsync().Result;
			foreach (DocumentSnapshot i in qSnap.Documents)
				res.Add(i.Id);

			return res;
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
		public static void GetRequestList(ObservableCollection<Request> requestlist)
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
			});
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

				int i = 0;
				while (dSnap.TryGetValue("image" + i, out temp))
				{
					images.Add((string)temp);
					i++;
				}

				Request res = dSnap.ConvertTo<Request>();
				res.Images = images;

				return res;
			}
			return null;
		}

		public static void UpdateRequest (string? email, string? date, string? docid, Request request, string UID, DateTime reservedtime)
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
				{"solved", request.solved!},
				{"userName", request.userName!},
			};

			int n = 0;
			foreach(string i in request.Images!)
			{
				dic.Add("image" + n, i);
				n++;
			}

			dRef.SetAsync(dic, SetOptions.MergeAll);

			//현장직 대기
			dRef = DB!.Collection("MangerScagul").Document(UID).Collection("scaul").Document("scaul").Collection(string.Format("{0:yyyy-MM-dd}", reservedtime) + " 수리예정").Document(request.DocID);
			dRef.SetAsync(dic, SetOptions.MergeAll).Wait();

			//현장직 예약 카운트
			query = DB!.Collection("MangerScagul").Document(UID).Collection("scaul").Document("scaul").Collection(string.Format("{0:yyyy-MM-dd}", reservedtime) + " 수리예정 ");
			dRef = DB!.Collection("MangerScagul").Document(UID).Collection("scaul").Document("scaul");
			Dictionary<string, object> update = new Dictionary<string, object>
			{
				{ string.Format("{0:yyyy-MM-dd}", reservedtime) + " 수리예정 " + request.Title, query.GetSnapshotAsync().Result.Count != 0 ? query.GetSnapshotAsync().Result.Count : FieldValue.Delete }
			};
			dRef.SetAsync(update, SetOptions.MergeAll).Wait();

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
						chatuserlist.Add(documentSnapshot.Id);
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
			Month = Month.AddMonths(-2);
			DocumentReference dRef = DB!.Collection("Bill").Document(email).Collection("Month").Document((Month.Month == 0 ? 12 : Month.Month) + "월");
			dRef.SetAsync(newbill, SetOptions.MergeAll);
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
