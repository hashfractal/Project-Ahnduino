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
		public int month { get; set; }
		[FirestoreProperty]
		public int pay { get; set; }

		public Bill(int month, int pay)
		{
			this.month = month;
			this.pay = pay;
		}

		public Bill() { }
	}
}
