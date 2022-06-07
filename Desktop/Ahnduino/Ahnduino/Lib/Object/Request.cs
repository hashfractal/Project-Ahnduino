using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using Google.Cloud.Firestore;
using Ahnduino.Lib;

namespace Ahnduino.Lib.Object
{
	[FirestoreData]
	public class Request
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
		public string? hopeTime0 { get; set; }
		[FirestoreProperty]
		public string? hopeTime1 { get; set; }
		[FirestoreProperty]
		public string? hopeTime2 { get; set; }
		[FirestoreProperty]
		public bool? Isreserve { get; set; }
		[FirestoreProperty]
		public string? Reserve { get; set; }
		[FirestoreProperty]
		public bool? solved { get; set; }
		[FirestoreProperty]
		public string? userName { get; set; }
		[FirestoreProperty]
		public string? fixholdtext { get; set; }
		[FirestoreProperty]
		public Timestamp? fixholdtime { get; set; }
		[FirestoreProperty]
		public string? 건물명 { get; set; }
		[FirestoreProperty]
		public string? 주소 { get; set; }
		[FirestoreProperty]
		public string? image0 { get; set; }
		[FirestoreProperty]
		public string? image1 { get; set; }
		[FirestoreProperty]
		public string? image2 { get; set; }
		[FirestoreProperty]
		public string? image3 { get; set; }
		[FirestoreProperty]
		public string? image4 { get; set; }

		[FirestoreProperty]
		public List<string>? Images { get; set; }

		public override string ToString()
		{
			return Fbad.GetAddress(UID!);	
		}
	}
}
