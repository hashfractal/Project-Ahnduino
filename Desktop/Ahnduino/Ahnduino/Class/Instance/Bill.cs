using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Google.Cloud.Firestore;

namespace Ahnduino
{
	[FirestoreData]
	internal class Bill
	{
		[FirestoreProperty]
		public DateTime Date { get; set; }
		[FirestoreProperty]
		public Boolean Pay { get; set; }
	}
}
