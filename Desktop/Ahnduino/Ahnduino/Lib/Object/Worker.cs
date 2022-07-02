using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Google.Cloud.Firestore;

namespace Ahnduino.Lib.Object
{
	[FirestoreData]
	public class Worker
	{
		[FirestoreProperty]
		public string? 근무지 { get; set; }
		[FirestoreProperty]
		public string? 이름 { get; set; }
		[FirestoreProperty]
		public string? 메일 { get; set; }
		[FirestoreProperty]
		public string? 전화번호 { get; set; }

		public override string ToString()
		{
			return string.Format("근무지: {0} | 이메일: {1} | 이름: {2} | 전화번호 {3}", 근무지, 메일, 이름, 전화번호);
		}
	}
}
