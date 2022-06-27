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

#pragma warning disable SYSLIB0022 // Null 경고 끄기

namespace Ahnduino.Lib
{
	//Fbad(FireBaseAhnDuino) 안두이노 사무직 클라이언트 기능 구현 정적 클래스
	public static class Fbad
	{
		static FirestoreDb? DB;

		public static FirestoreDb GetDb { get { return DB!; } }

		//기본 생성자, 생성이 되면서 파이어스토어 객체를 DB에 생성
		static Fbad()
		{
			//string path = "ahnduino-firebase-adminsdk-ddl6q-daf19142ac.json";
			//System.Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", path);
			//DB = FirestoreDb.Create("ahnduino");

			string path = "rijon-681a0-firebase-adminsdk-mrnlm-0cfd96aa13.json";
			System.Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", path);

			DB = FirestoreDb.Create("rijon-681a0");
		}

		//전체주소(주소+(건물명))을 주면 해당 주소에 할당된 유저의 이메일 반환
		public static string getEmail(string fulladdress)
		{
			DocumentReference dRef = DB!.Collection("Building").Document(fulladdress);	//DocumentReference: 참조할 문서의 주소
			DocumentSnapshot dSnap = dRef.GetSnapshotAsync().Result;					//DocumentSnapshot: 파이어스토어에서 가져온 문서 객체(실체가 있음)
			dSnap.TryGetValue("인증번호", out string temp);                             //TryGetValue: 문서 스냅샷에서 특정한 값을 가져올 때 사용
			Query query = DB!.Collection("User").WhereEqualTo("인증번호", temp);
			QuerySnapshot qSnap = query.GetSnapshotAsync().Result;                      //GetSnapshotAsync: 쿼리를 실행
																						//QuerySnapshot: 쿼리실행시킨 결과물 객체(실체가 있음) 
			return qSnap.Documents[0].Id;                                               //QuerySnapshot.Documents: 쿼리 스냅샷의 문서 스냅샷 배열
			//Documents[0]->쿼리 결과물의 첫번째 객체 (== DocumentSnapshot.id -> 문서id)
		}

		//이메일을 주면 전체주소 반환
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

		//인터넷 이미지 링크로 WPF의 이미지 컨트롤 생성후 반환
		public static Image GetImageFromUri(string uri)
		{
			//WPF이미지 객체
			Image image = new Image();

			//비트맵 이미지 객체
			BitmapImage bitmap = new BitmapImage();
			bitmap.BeginInit();
			//Uri에서 이미지 가져오기
			bitmap.UriSource = new Uri(@uri, UriKind.Absolute);
			bitmap.EndInit();

			//WPF이미지를 비트맵 이미지와 연결
			image.Source = bitmap;

			return image;
		}

		//건물관리
		#region Build

		//전체주소-> 건물 고유변호
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

		//건물 고유번호 -> 전체주소
		public static string? SerialNoToAddress(string SerialNo)
		{
			Query query = DB!.Collection("Building").WhereEqualTo("인증번호", SerialNo);
			QuerySnapshot qSnap = query.GetSnapshotAsync().Result;
			return qSnap.Documents[0].Id;
		}

		//전체주소 -> 이메일
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

		//!건물 객체는 건물 하나가 아닌 건물에있는 방 하나를 의미!
		//주소(전체주소x (건물명)이 없음)에 해당하는 건물 리스트 반환 (ex 대전 동구 자양동 11 -> 11아파트1호, 11아파트2호...)
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

		//전체주소에 해당하는 건물 객체 반환
		public static Build GetBuildFormFullAddress(string fulladdress)
		{
			DocumentReference dRef = DB!.Collection("Building").Document(fulladdress);
			DocumentSnapshot dSnap = dRef.GetSnapshotAsync().Result;

			return dSnap.ConvertTo<Build>();
		}

		//건물 고유번호에 해당하는 건물 반환
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
		
		//건물의 관리비 가져오기
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

		//건물추가
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

		//건물삭제
		public static void DeleteBuild(string fulladdress)
		{
			DocumentReference dRef = DB!.Collection("Building").Document(fulladdress);
			dRef.DeleteAsync();
		}

		//건물 추가할 때 유효성 검사
		public static string validationBuild(string address, string buildname, string buildid)
		{
			string res = "";
			DocumentReference dRef = DB!.Collection("Building").Document(address + "(" + buildname + ")");
			DocumentSnapshot dSnap = dRef.GetSnapshotAsync().Result;
			Query query = DB!.Collection("Building").WhereEqualTo("인증번호", buildid);
			QuerySnapshot qSanp = query.GetSnapshotAsync().Result;

			//동일한 전체주소가 있을 때
			if (dSnap.Exists)
				res += "이미 등록된 주소입니다\r\n";
			//동일한 건물 인증번호가 있을 때
			if (qSanp.Count > 0)
				res += "이미 등록된 건물 인증번호 입니다\r\n";
			//res가 ""이라면 유효성 검사 성공 아니면 실패
			return res;
		}
		#endregion

		//로그인
		#region Auth

		//회원가입 이메일 유효성검사
		public static bool IsValidEmail(string email)
		{
			return Regex.IsMatch(email, @"[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?");
		}

		//회원가입 전화번호 유효성검사
		public static bool IsValidPhone(string phone)
		{
			return Regex.IsMatch(phone, @"010-[0-9]{4}-[0-9]{4}$");
		}

		//회원가입 유효성검사
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

		//로그인
		public static bool Login(string email, string password)
		{
			//비밀번호가 암호화 된 password와 일치하는 문서를 가져옴
			Query qref = DB!.Collection("Manager").WhereEqualTo("Email", email).WhereEqualTo("Password", EncryptString(password, "flawless ahnduino"));
			QuerySnapshot snap = qref.GetSnapshotAsync().Result;

			foreach (DocumentSnapshot docsnap in snap)
			{
				if (docsnap.Exists)
				{
					//문서가있다면
					return true;
				}
			}
			//문서가없다면
			return false;
		}

		//회원가입 공백 검사
		public static void Register(string email, string password, string repassword, string name, string phone)
		{
			if (email == "" || password == "" || repassword == "" || name == "" || phone == "") //공백이 입력될 경우
			{
				/*MessageBox.Show("아이디 또는 비밀번호에 공백이 있습니다.");*/
				return;
			}
			JoinManagement(email, password, name, phone);
		}

		//회원가입 중복검사
		private static void JoinManagement(string email, string password, string name, string phone)
		{
			bool idCheck = FindId(email);
			if (idCheck) { } //id가 이미 있으므로 회원가입 X
			else if (!idCheck) //id가 없으므로 회원가입 O
			{
				Join(email, password, name, phone);
			}
		}

		//회원가입 파이어스토어 문서 등록
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

		//이메일에 해당하는 문서가 있는지 확인
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

		//비밀번호 초기화
		public static string ResetEmail(string email)
		{
			//임시 비빌번호에 사용될 수 있는 문자들
			var characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

			//임시 비밀번호 문자열
			var Charsarr = new char[8];
			var random = new Random();

			//임시비밀번호 문자열 생성
			for (int i = 0; i < Charsarr.Length; i++)
			{
				Charsarr[i] = characters[random.Next(characters.Length)]; //characters문자열 길이보다 작은 양의 정수를 랜덤으로 특정하고,
																		  //characters문자열의 특정된 정수번 째 문자를 Charsarr[i]에 대입
			}
			
			//문자 배열을 string으로 변환
			string resultString = new string(Charsarr);

			DocumentReference DOC = DB!.Collection("Manager").Document(email);
			Dictionary<string, object> temp = new Dictionary<string, object>()
			{
				//생성된 임시 비밀번호를 암호화여 DB에 업로드
				{"Password", EncryptString(resultString,"flawless ahnduino") }
			};
			DOC.UpdateAsync(temp);

			return resultString;
		}

		// 암호화 AES256 InputText: 입력된 텍스트, Password 내부 비밀번호
		// 내부 비밀번호에 따라서 입력된 텍스트가 암호화된 결과가 달라짐
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

		//수리요청
		#region Request

		//요청 목록 가져오기 매개변수로 요청 목록을 전달받을 requestlist, 요청목록 스냅샷, 퇴실신청목록 쿼리 스냅샷을 받음
		static void GetTotalRequestList(ObservableCollection<Request> requestlist, QuerySnapshot request, QuerySnapshot roomout)
		{
			//시스템쓰레딩의 task 사용
			Task.Factory.StartNew(() =>
			{
				//Task쓰레드에서 WPF메인 쓰레드에 접근하기 때문에 Dispatcher 사용
				DispatcherService.Invoke(() =>
				{
					Request temp = new Request();
					requestlist.Clear();

					//수리요청 처리가 필요한 사용자 문서를 순회
					foreach (DocumentSnapshot documentSnapshot in request.Documents)
					{
						DocumentReference dRef = documentSnapshot.Reference;

						//사용자 문서의 수리 목록("2022-06-06예약 전" 같은 컬렉션) 컬렉션을 가져옴
						IAsyncEnumerable<CollectionReference> clist = dRef.Collection("Request").Document("Request").ListCollectionsAsync();
						IAsyncEnumerator<CollectionReference> subcollectionsEnumerator = clist.GetAsyncEnumerator(default);

						//가져온 컬렉션을 순회, MoveNextAsync에서 다음 문서가 없으면 false리턴, while 중지 사실상 foreach(IAsyncEnumerator 순회에서는 foreach를 못씀)
						while (subcollectionsEnumerator.MoveNextAsync().Result)
						{
							CollectionReference i = subcollectionsEnumerator.Current; //순회 중 현재 컬렉션 객체

							//컬렉션 id길이가 14자라면("~예약 전" 인경우)
							if (i.Id.Length == 14)
							{
								QuerySnapshot qsnp = i.GetSnapshotAsync().Result;

								//해당 컬렉션에 있는 문서를 가져옴
								foreach (DocumentSnapshot ds in qsnp.Documents)
								{
									//가져온 문서를 Request객체로 변환
									temp = ds.ConvertTo<Request>();
									temp.Images = new List<string>();
									Dictionary<string, object> dict = ds.ToDictionary();

									int n = 0;

									//이미지가 있다면 이미지 링크를 객체에 추가, 이미지 없으면 TryGetValue에서 false 리턴
									while (dict.TryGetValue("image" + n, out object? temp2))
									{
										temp.Images.Add((string)temp2);
										n++;
									}
									DispatcherService.Invoke(() =>
									{
										//완성된 수리요청 객체를 리스트에추가
										requestlist.Add(temp);
									});
								}
							}
						}
					}

					//퇴실 신청 목록 순회
					foreach (DocumentSnapshot i in roomout.Documents)
					{
						//퇴실신청 객체 생성
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

						//완성된 퇴실신청 객체를 리스트에 추가
						requestlist.Add(request);
					}
				});
			});
		}

		//FirestoreChangeListener: 쿼리에 해당하는 문서의 변화(문서 생성, 문서 삭제 포함)를 감지하며, 문서에 변화가 생기면 리스너호출
		public static void GetRequestList(ObservableCollection<Request> requestlist)
		{
			Query query = DB!.Collection("ResponsAndReQuest").WhereEqualTo("isdone", false);
			Query query2 = DB!.Collection("RoomOut");

			FirestoreChangeListener listener = query.Listen(snapshot => //수리요청 처리가 필요한 사용자가 생기면 호출
			{
				QuerySnapshot qSnap = query2.GetSnapshotAsync().Result;
				GetTotalRequestList(requestlist, snapshot, qSnap); //snapshot-> 수리신청 스냅샷, qSnap -> 퇴실 스냅샷, 수리신청과 퇴실을 한 목록에 보여주기 위해서
																   //수리 신청만 감지가 되어도 퇴실 목록도 가져옴
			});

			FirestoreChangeListener listener2 = query2.Listen(snapshot =>  //퇴실신청 처리가 필요한 사용자가 생기면 호출
			{
				QuerySnapshot qSnap = query.GetSnapshotAsync().Result;
				GetTotalRequestList(requestlist, qSnap, snapshot);  //qSnap-> 수리신청 스냅샷, snapshot -> 퇴실 스냅샷, 수리신청과 퇴실을 한 목록에 보여주기 위해서
																	//퇴실만 감지가 되어도 수리 신청 목록을 가져옴
			});
		}

		//수리요청 예약
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
			
			//!!!!!!!!!!!!!!! SetAsync(object, SetOptions.MergeAll) 경로에 문서가 없다면 새로 만듬 문서가 있다면 기존 문서와 병합->기존 문서에서 변경점이 없는 필드는 기존문서 유지
			//																													 ->기존 문서에서 필드가 변하거나 새로 생겼다면 갱신
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

		//수리요청 삭제(취소)
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

		//현장직 콤보박스 설정
		public static void SetWorkerComboBox(ComboBox Region, ComboBox Gu, ComboBox Dong)
		{

			List<string> regionlist = new List<string>();
			List<string> gulist = new List<string>();
			List<string> donglist = new List<string>();

			DocumentReference dRef = DB!.Collection("WorkerAdress").Document("address");
			DocumentSnapshot dSnap = dRef.GetSnapshotAsync().Result;

			Dictionary<string, object> dict = dSnap.ToDictionary();

			//현장직 주소 리스트 순회
			foreach (KeyValuePair<string, object> i in dict)
			{
				//공백으로 단어를 나눔
				string[] strs = i.Key.Split(' ');

				
					//나눈 단어개수가 (대전 동구 자양동 : 3) 0보다 클 때
					if (strs.Count() > 0)
					{
						//리스트에 동일한 단어가 없다면 나눈 단어의 0번째를 추가
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

		//현장직 주소 콤보박스가 설정 되었을 때 현장직 목록 설정
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

		//보류
		#region FixHold
		//보류 목록 가져오기
		public static List<Request> GetFixHoldList()
		{
			List<Request> res = new List<Request>();
			Query query = DB!.Collection("FixHold");
			QuerySnapshot qSnap = query.GetSnapshotAsync().Result;

			foreach(DocumentSnapshot i in qSnap.Documents)
			{
				Query qry = DB!.Collection("FixHold").Document(i.Id).Collection("FixHold");
				QuerySnapshot qsp = qry.GetSnapshotAsync().Result;

				foreach(DocumentSnapshot j in qsp.Documents)
				{
					Request fixHold = j.ConvertTo<Request>();
					fixHold.worker = i.Id;

					res.Add(fixHold);
				}
			}   

			return res;
		}

		//보류 삭제 및 카운트(삭제후 FixHoldMenu.xaml.cs에서 예약 함수 호출 해 줌)
		public static void RemoveFixHold(Request request)
		{
			//보류 컬렉션과 수리요청 컬렉션의 보류 문서 삭제
			DocumentReference dRef = DB!.Collection("FixHold").Document(request.worker).Collection("FixHold").Document(request.DocID);
			dRef.DeleteAsync().Wait();
			dRef = DB!.Collection("ResponsAndReQuest").Document(request.UID).Collection("Request").Document("Request").Collection(request.Date + " 수리보류").Document(request.DocID);
			dRef.DeleteAsync().Wait();

			//수리요청 컬렉션 수리 보류 카운트
			dRef = DB!.Collection("ResponsAndReQuest").Document(request.UID).Collection("Request").Document("Request");
			DocumentSnapshot dSnap = dRef.GetSnapshotAsync().Result;
			dSnap.TryGetValue(request.Date + " 수리보류", out int count);
			count--;

			Dictionary<string, object> updates = new Dictionary<string, object>
			{
				{ request.Date + " 수리보류", count > 0 ? count : FieldValue.Delete } //FieldValue.Delete: 필드를 삭제 
			};
			dRef.SetAsync(updates, SetOptions.MergeAll).Wait();
		}
		#endregion

		//채팅
		#region Chat
		//채팅 목록을 처음 열었을 때 채팅 리스트 가져오기
		public static void FirstGetChatList(string email, ObservableCollection<Chat> chatlist)
		{
			chatlist.Clear();
			CollectionReference collectionRef = DB!.Collection("chat").Document("chat").Collection(email);

			//내림차순으로 10개 가져옴(최신꺼부터 10개)
			Query query = collectionRef.OrderByDescending("time").Limit(10);
			QuerySnapshot qSnap = query.GetSnapshotAsync().Result;

			//가져온문서를 순회해서 채팅 리스트에 넣기
			//쿼리 스냅샷이 최신이 0번째고 오래된 채팅일수록 n번째인 구조인데 리스트에서는 오래된것이0이고 최신이 n번째여야함
			//따라서 스냅샷 순서를 Reverse() 메서드로 역순으로 해줌
			foreach(DocumentSnapshot dSnap in qSnap.Documents.Reverse())
			{
				//채팅 이미지 가져오기
				Dictionary<string, object> dict = dSnap.ToDictionary();
				List<string> images = new();

				object temp;

				int i = 0;
				while (dSnap.TryGetValue("image" + i, out temp))
				{
					images.Add((string)temp);
					i++;
				}

				//이미지 외 채팅 항목들을 Chat 객체로 변환
				Chat res = dSnap.ConvertTo<Chat>();
				//채팅 객체에 이미지목록 할당
				res.imagelist = images;

				//List<string>인 이미지 목록을 WPF이미지 리스트로 저장해줌
				res.trueimage = new List<Image>();
				foreach(string j in res.imagelist)
				{
					Image img = GetImageFromUri(j);
					img.Height = 200;
					img.Width = 200;
					res.trueimage!.Add(img);
				}

				res.address = GetAddress(email);

				//!! 클래스멤버인 파이어스토어 Timestamp를 사용하려면 새로운 timestamp객체를 만들어서 클래스에 있는 타임스탬프를 참조하게 해야 함 구글이 이렇게만듬...
				Timestamp timestamp = (Timestamp)res.time!;
				DateTime dateTime = timestamp.ToDateTime();
				dateTime = dateTime.AddHours(9);
				res.date = string.Format("{0:yyyy년 M월 d일 dddd}", dateTime);

				//채팅이 해당 날짜를 처음인지를 판단, xaml상에서 날짜를 띄워줄 때 사용함
				if(chatlist.Count == 0 || chatlist[chatlist.Count-1].date != res.date)
				{
					res.isfirst = true;
				}

				chatlist.Add(res);
				
			}
			Console.WriteLine("Done");
		}

		//채팅 목록을 추가로 불러올 때 사용
		//==알고리즘==
		//전체 채팅이 0~10 까지 있고 현재 0~5까지 있는상황, 0이 최신 10이 가장 오래된 것
		//6~8까지만 불러오려고 함
		//1. 쿼리를 날짜 내림차순으로 3개까지만 실행시킨다 (실제 프로그램상에서는 10개) 6이 날짜가 가장 크기(가장 최신) 때문에 처음으로 오며 7, 8이 순서대로 오게된다
		//2. 채팅 배열은 처음에는 가장 오래된것 마지막에는 가장 최신의것 이 있는 구조이다
		//3. 따라서 쿼리에서 얻은 배열들을 순서대로 채팅 배열의 첫번째에 삽입해주면 된다 큐의 삽입과 유사한 구조이다.
		public static void GetChatList(string email, ObservableCollection<Chat> chatlist)
		{
			ObservableCollection<Chat> list = new ObservableCollection<Chat>();
			CollectionReference collectionRef = DB!.Collection("chat").Document("chat").Collection(email);
			Query query = collectionRef.WhereLessThan("time", chatlist.First().time).OrderByDescending("time").Limit(10);
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
				res.address = GetAddress(email);

				//불러온 결과가 있는 임시 리스트
				list.Add(res);
			}

			//임시리스트에있는 값들을 채팅리스트에 넣어줌
			//임시리스트의 정렬 순서는 내림차순이며 채팅 리스트의 0번째에 넣음(큐의 삽입과 유사)
			foreach(Chat i in list)
			{
				
				Timestamp timestamp = (Timestamp)i.time!;
				DateTime dateTime = timestamp.ToDateTime();
				dateTime = dateTime.AddHours(9);
				i.date = string.Format("{0:yyyy년 M월 d일 dddd}", dateTime);

				//만약 채팅 리스트의 0번째 날짜가 i와 같으면 i가 당일의 첫 번째 채팅이 된다
				//따라서 채팅리스트의 0번째의 첫 번째 채팅 상태를 해제 해준다.
				if (chatlist[0].date == i.date)
				{
					chatlist[0].isfirst = null;
				}

				//i는 채팅리스트의 첫 번째에 있기때문에 항상 첫 번째 채팅 상태이다
				//먄악 임시 목록에서 다음번 i가 현재 i와 날짜가같으면 1000줄 코드에서 첫번째 상태를 해제 해주게 된다
				i.isfirst = true;

				//i를 채팅리스트의 0번째에 넣는다 기존에 있던 항목들은 순서가 밀리게된다
				chatlist.Insert(0, i);
			}
			Console.WriteLine("GetChatListDone");
		}

		//새로운 채팅을 받는 메서드
		public static void GetChat(string? email, ObservableCollection<Chat> chatlist, ScrollViewer scrollViewer)
		{
			//채팅방을 나갔을 때 리스너를 종료시키기 위한 설정 코드 최하단 참고
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

					Timestamp timestamp = (Timestamp)chat.time!;
					DateTime dateTime = timestamp.ToDateTime();
					dateTime = dateTime.AddHours(9);
					chat.date = string.Format("{0:yyyy년 M월 d일 dddd}", dateTime);

					if (chatlist.Count == 0 || chatlist[chatlist.Count-1].date != chat.date)
					{
						chat.isfirst = true;
					}

					chat.address = GetAddress(email);

					chatlist.Add(chat);
				});
			});

			//불필요한 리스너가 열려있으면 최적화상에서 좋지않다. 스톱 어싱크로 리스너를 꺼야한다.
			if (email == "null")
			{
				listener.StopAsync();
			}
			Console.WriteLine("GetChatDone");
		}

		//답변이 필요한 유저 리스트 가져오기
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

		//채팅 이미지 업로드
		public static async Task<string> UploadChatImg(string email, string path, string docid)
		{
			var stream = File.Open(@path, FileMode.Open);

			// Construct FirebaseStorage with path to where you want to upload the file and put it there
			var task = new FirebaseStorage("ahnduino.appspot.com")//!!파이어스토어DB가 아닌 파이어베이스스토리지(파일이 올라가는그곳)!!
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

		//채팅 보내기
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
		
		//이미지 보내기
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

		//사무직이 답변을 했을때 처리
		public static void answerdone(string email)
		{
			DocumentReference dRef = DB!.Collection("chat").Document("chat").Collection("needanswer").Document(email);
			dRef.DeleteAsync();
		}
		#endregion

		//고지서
		#region Bill

		//고지서 리스트 가져오기
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

		//미납요금이나 수리비가 발생한 유저 리스트 가져오기
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

		//수리비납부 확인 처리
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

		//새로운 고지서를 프로그램에서 만들기(업로드 x)
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
				DocumentReference DR = DB!.Collection("Building").Document(GetAddress(email!));
				DocumentSnapshot DS = DR.GetSnapshotAsync().Result;

				DS.TryGetValue("관리비", out int pay);
				DS.TryGetValue("연체료", out int unpay);

				newbill.Ab = 2;
				newbill.Arrears = unpay;
				newbill.Defmoney = 0;
				newbill.Money = pay;
				newbill.Nab = null;
				newbill.Pay = false;
				newbill.Pomoney = null;
				newbill.Repair = 0;
				newbill.Totmoney = null;
			}
		}

		//고지서 업로드
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
		#endregion

		//공지
		#region Board

		//게시판 목록 불러오기
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

		//게시판 검색
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

		//새 공지 만들기
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

		//이미지를 파베 스토리지에 업로드
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

		//게시판에 이미지 추가
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

		//갤러리
		#region Info
		//갤러리 입퇴실 불러오기
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

		//갤러리 수리목록 불러오기
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
	}
}
