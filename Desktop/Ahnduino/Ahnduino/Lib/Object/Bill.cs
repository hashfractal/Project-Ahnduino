using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Google.Cloud.Firestore;

namespace Ahnduino.Lib.Object
{
	[FirestoreData]
	internal class Bill
	{
		[FirestoreProperty]
		int? Ab { get; set; }
		[FirestoreProperty]
		int? Arrears { get; set; }
		[FirestoreProperty]
		int? Defmoney { get; set; }
		[FirestoreProperty]
		int? Money { get; set; }
		[FirestoreProperty]
		Timestamp? Nab { get; set; }
		[FirestoreProperty]
		bool? Pay { get; set; }
		[FirestoreProperty]
		int? Pomoney { get; set; }
		[FirestoreProperty]
		int? Repair { get; set; }
		[FirestoreProperty]
		int? Totmoney { get; set; }
	}
}
