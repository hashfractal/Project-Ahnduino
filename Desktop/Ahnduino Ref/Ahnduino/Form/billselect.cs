using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Ahnduino
{
	public partial class billselect : MetroFramework.Forms.MetroForm
	{
		FireBase FireBase = new FireBase();

		List<Bill> bills = new List<Bill>();
		Bill bill = null;

		int paypermonth = 0;

		#region userdeffunc
		private int datetonumer(string billdate)
		{
			string[] temps = billdate.Split('-');
			string temp = temps[0] + temps[1];
			return int.Parse(temp);
		}
		#endregion

		
		
		public billselect()
		{
			InitializeComponent();
		}

		private void metroComboBoxdate_SelectedIndexChanged(object sender, EventArgs e)
		{
			int misspay = 0;
			int totalpay = 0;
			bill = bills[metroComboBoxdate.SelectedIndex];

			for (int i = 0; i < bills.FindIndex(x => x == bill); i++)
			{
				if (bills[i].pay < paypermonth)
				{
					misspay += paypermonth - bills[i].pay;
				}
			}

			totalpay = paypermonth + misspay;

			if (bill.pay == paypermonth)
			{
				metroToggle1.Checked = true;
			}
			else
			{
				metroToggle1.Checked = false;
			}

			metroLabelresaddress.Text = metroTextBoxsearch.Text;
			metroLabelrespay.Text = bill.pay == paypermonth ? "완납" : "미납";
			metroLabelresdate.Text = string.Format("{0}월분", bill.month);
			metroLabelresmoney.Text = string.Format("당월 부과액: {0}원", paypermonth);
			metroLabelresmiss.Text = string.Format("미납액: {0}원", misspay);
			metroLabelrestotalmoney.Text = string.Format("총 부과액: {0}원", totalpay);
			metroLabelreslimit.Text = string.Format("납부 마감일 {0}월 30일", bill.month + 1);
		}

		private void metroButton1_Click(object sender, EventArgs e)
		{
			List<Bill> temp = bills;
			bills = FireBase.GetBillList(metroTextBoxsearch.Text, out paypermonth);
			metroComboBoxdate.Items.Clear();

			if(bills != null)
			{
				foreach (Bill bill in bills)
					metroComboBoxdate.Items.Add(bill.month);
				metroComboBoxdate.SelectedIndex = metroComboBoxdate.Items.Count - 1;
			}
			else
			{
				bills = temp;
			}
			
		}

		private void metroTextBoxsearch_Enter(object sender, EventArgs e)
		{
			if(metroTextBoxsearch.Text == "건물 주소 +호수   예) 동대전로1번길1롤아파트a동101호")
			{
				metroTextBoxsearch.ForeColor = Color.Black;
				metroTextBoxsearch.Text = "";
			}
		}

		private void metroTextBoxsearch_Leave(object sender, EventArgs e)
		{
			if (metroTextBoxsearch.Text == "")
			{
				metroTextBoxsearch.ForeColor = Color.Gray;
				metroTextBoxsearch.Text = "건물 주소 +호수   예) 동대전로1번길1롤아파트a동101호";
			}
		}

		private void billselect_Load(object sender, EventArgs e)
		{
			metroTextBoxsearch.Text = "건물 주소 +호수   예) 동대전로1번길1롤아파트a동101호";
		}

		private void metroToggle1_CheckedChanged(object sender, EventArgs e)
		{
			bill.pay = metroToggle1.Checked ? 0 : paypermonth;
			metroLabelrespay.Text = bill.pay == paypermonth ? "완납" : "미납";

			if(metroToggle1.Checked)
			{
				for (int i = 0; i < bills.FindIndex(x => x == bill); i++)
				{
					bills[i].pay = paypermonth;
				}
			}
			

			metroComboBoxdate_SelectedIndexChanged(sender, e);

		}

		private void metroButtonupdate_Click(object sender, EventArgs e)
		{
			FireBase.UpdateBillList(bills, metroTextBoxsearch.Text);
		}

		private void metroButtoninsert_Click(object sender, EventArgs e)
		{
			Bill temp = null;
				
			if (bills.Count == 0)
			{	
				addbill addbill = new addbill();
				addbill.ShowDialog();
				temp = new Bill(int.Parse(addbill.metroComboBoxmonth.Text), 0);
			}
			else
			{
				if (bills.Count > 11)
					bills.RemoveAt(0);

				temp = new Bill(bills[bills.Count - 1].month == 12 ? 
					1 : bills[bills.Count - 1].month + 1,
					0);
			}

			bills.Add(temp);

			FireBase.UpdateBillList(bills, metroTextBoxsearch.Text);

			metroButton1_Click(sender, e);
		}

		private void metroButtondelete_Click(object sender, EventArgs e)
		{
			bills.RemoveAt(bills.Count - 1);
			FireBase.UpdateBillList(bills, metroTextBoxsearch.Text);
			metroButton1_Click(sender, e);
		}
	}
}
