using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Google.Cloud.Firestore;

[FirestoreData]
public class Bill
{
	[FirestoreProperty]
	public int? Ab { get; set; }
	[FirestoreProperty]
	public int? Arrears { get; set; }
	[FirestoreProperty]
	public int? Defmoney { get; set; }
	[FirestoreProperty]
	public int? Money { get; set; }
	[FirestoreProperty]
	public Timestamp? Nab { get; set; }
	[FirestoreProperty]
	public bool? Pay { get; set; }
	[FirestoreProperty]
	public int? Pomoney { get; set; }
	[FirestoreProperty]
	public int? Repair { get; set; }
	[FirestoreProperty]
	public int? Totmoney { get; set; }

	public override string ToString()
	{
		Timestamp temp = (Timestamp)Nab!;

		return (temp.ToDateTime().Month - 1 == 0 ? 12 : temp.ToDateTime().Month - 1).ToString();
	}
}
