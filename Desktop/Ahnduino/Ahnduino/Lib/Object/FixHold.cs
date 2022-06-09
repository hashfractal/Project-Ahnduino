using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Google.Cloud.Firestore;

namespace Ahnduino.Lib.Object
{
	[FirestoreData]
	public class FixHold
	{
		[FirestoreProperty]
		public string? Date { get; set; }

		[FirestoreProperty]
		public string? DocID { get; set; }

		[FirestoreProperty]
		public string? Text { get; set; }

		[FirestoreProperty]
		public Timestamp? Time { get; set; }

		[FirestoreProperty]
		public string? Title { get; set; }

		[FirestoreProperty]
		public string? UID { get; set; }

		[FirestoreProperty]
		public string? fixholdtext { get; set; }

		[FirestoreProperty]
		public Timestamp? fixholdtime { get; set; }

		[FirestoreProperty]
		public bool? isreserv { get; set; }

		[FirestoreProperty]
		public string? reserv { get; set; }

		[FirestoreProperty]
		public Timestamp? reservTime { get; set; }

		[FirestoreProperty]
		public bool? solved { get; set; }

		[FirestoreProperty]
		public string? userName { get; set; }

		[FirestoreProperty]
		public string? 건물명 { get; set; }

		[FirestoreProperty]
		public string? 주소 { get; set; }

		public string? worker { get; set; }

		public override string ToString()
		{
			return worker!;
		}
	}
}
