using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Google.Cloud.Firestore;

namespace Ahnduino.Lib.Object
{
	[FirestoreData]
	public class Build
	{
		[FirestoreProperty]
		public bool? Used { get; set; }

		[FirestoreProperty]
		public string? 건물명 { get; set; }

		[FirestoreProperty]
		public int? 관리비 { get; set; }

		[FirestoreProperty]
		public bool? 미납 { get; set; }

		[FirestoreProperty]
		public bool? 수리비 { get; set; }

		[FirestoreProperty]
		public string? 인증번호 { get; set; }

		[FirestoreProperty]
		public string? 주소 { get; set; }

		public override string ToString()
		{
			return 건물명!;
		}
	}
}
