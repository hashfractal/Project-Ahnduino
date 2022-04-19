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
		public string date { get; set; }
		[FirestoreProperty]
		public bool pay { get; set; }

		public Bill(string date, bool pay)
		{
			this.date = date;
			this.pay = pay;
		}

		public Bill() { }
	}
}
