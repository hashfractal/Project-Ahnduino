﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using Ahnduino.Lib;

namespace Ahnduino.Wins
{
	/// <summary>
	/// BuildMenu.xaml에 대한 상호 작용 논리
	/// </summary>
	public partial class BuildMenu : Window
	{
		public BuildMenu()
		{
			InitializeComponent();
		}

		private void bsearchbuild_Click(object sender, RoutedEventArgs e)
		{
			LVUserlist.Items.Clear();
			foreach(string i in Fbad.AddressToEmailList(textboxemail.Text))
			{
				LVUserlist.Items.Add(i);
			}
			textboxID.Text = Fbad.AddressToSerialNo(textboxemail.Text);
			tbpay.Text = Fbad.GetPayFromAddress(textboxemail.Text!).ToString();
		}

		private void bbuildid_Click(object sender, RoutedEventArgs e)
		{
			LVUserlist.Items.Clear();
			textboxemail.Text = Fbad.SerialNoToAddress(textboxID.Text);
			foreach (string i in Fbad.AddressToEmailList(textboxemail.Text!))
			{
				LVUserlist.Items.Add(i);
			}
			tbpay.Text = Fbad.GetPayFromAddress(textboxemail.Text!).ToString();
		}
	}
}