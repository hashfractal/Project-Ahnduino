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

	#region Bill
	public static void UpdateAllBill()
	{
		Query query = DB!.Collection("Building").WhereEqualTo("Used", true);
		QuerySnapshot qSnap = query.GetSnapshotAsync().Result;
		//세입자가 있는 건물 문서 완전탐색
		foreach(DocumentSnapshot i in qSnap.Documents)
		{
			//고지서 자동 업데이트 조건
			i.TryGetValue("수리비", out bool isfix);
			i.TryGetValue("미납", out bool nopay);
			if (!isfix && !nopay)
			{
				Dictionary<string, object> dic = new Dictionary<string, object>
				{
					{ "미납", true },
				};

				i.Reference.SetAsync(dic, SetOptions.MergeAll);

				i.TryGetValue("주소", out string address);
				i.TryGetValue("건물명", out string buildname);
				i.TryGetValue("관리비", out int pay);
				i.TryGetValue("연체료", out int unpay);

				string user = getEmail(address + "(" + buildname + ")");

				Query qr = DB!.Collection("Bill").Document(user).Collection("Month").OrderByDescending("Nab");
				QuerySnapshot qss = qr.GetSnapshotAsync().Result;

				Bill newbill = new();
				newbill.Ab = 2;
				newbill.Arrears = unpay;
				newbill.Defmoney = 0;
				newbill.Money = pay;
				DateTime dateTime = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 20, 0, 0, 0);
				dateTime = dateTime.AddMonths(1);
				newbill.Nab = Timestamp.FromDateTime(dateTime.ToUniversalTime());
				newbill.Pay = false;
				newbill.Pomoney = newbill.Money + newbill.Arrears;
				newbill.Repair = 0;
				newbill.Totmoney = newbill.Money;

				CreateBill(user, newbill, qss.Count);
			}
		}
	}

	public static void CreateBill(string? email, Bill newbill, int billlistcount)
	{
		if (billlistcount >= 12)
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
}
