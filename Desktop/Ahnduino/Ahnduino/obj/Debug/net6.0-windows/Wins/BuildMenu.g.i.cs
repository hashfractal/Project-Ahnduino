﻿#pragma checksum "..\..\..\..\Wins\BuildMenu.xaml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "DCD6D12A5C4654E3F1DDFC0938D3EDF7E1462C6E"
//------------------------------------------------------------------------------
// <auto-generated>
//     이 코드는 도구를 사용하여 생성되었습니다.
//     런타임 버전:4.0.30319.42000
//
//     파일 내용을 변경하면 잘못된 동작이 발생할 수 있으며, 코드를 다시 생성하면
//     이러한 변경 내용이 손실됩니다.
// </auto-generated>
//------------------------------------------------------------------------------

using Ahnduino.Wins;
using System;
using System.Diagnostics;
using System.Windows;
using System.Windows.Automation;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Controls.Ribbon;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Markup;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Media.Effects;
using System.Windows.Media.Imaging;
using System.Windows.Media.Media3D;
using System.Windows.Media.TextFormatting;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Shell;


namespace Ahnduino.Wins {
    
    
    /// <summary>
    /// BuildMenu
    /// </summary>
    public partial class BuildMenu : System.Windows.Window, System.Windows.Markup.IComponentConnector {
        
        
        #line 30 "..\..\..\..\Wins\BuildMenu.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox textboxemail;
        
        #line default
        #line hidden
        
        
        #line 50 "..\..\..\..\Wins\BuildMenu.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button bsearchbuild;
        
        #line default
        #line hidden
        
        
        #line 60 "..\..\..\..\Wins\BuildMenu.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.ListView LVUserlist;
        
        #line default
        #line hidden
        
        
        #line 87 "..\..\..\..\Wins\BuildMenu.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox textboxID;
        
        #line default
        #line hidden
        
        
        #line 107 "..\..\..\..\Wins\BuildMenu.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button bbuildid;
        
        #line default
        #line hidden
        
        
        #line 125 "..\..\..\..\Wins\BuildMenu.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox tbpay;
        
        #line default
        #line hidden
        
        private bool _contentLoaded;
        
        /// <summary>
        /// InitializeComponent
        /// </summary>
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "6.0.4.0")]
        public void InitializeComponent() {
            if (_contentLoaded) {
                return;
            }
            _contentLoaded = true;
            System.Uri resourceLocater = new System.Uri("/Ahnduino;component/wins/buildmenu.xaml", System.UriKind.Relative);
            
            #line 1 "..\..\..\..\Wins\BuildMenu.xaml"
            System.Windows.Application.LoadComponent(this, resourceLocater);
            
            #line default
            #line hidden
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "6.0.4.0")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Design", "CA1033:InterfaceMethodsShouldBeCallableByChildTypes")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1800:DoNotCastUnnecessarily")]
        void System.Windows.Markup.IComponentConnector.Connect(int connectionId, object target) {
            switch (connectionId)
            {
            case 1:
            this.textboxemail = ((System.Windows.Controls.TextBox)(target));
            return;
            case 2:
            this.bsearchbuild = ((System.Windows.Controls.Button)(target));
            
            #line 50 "..\..\..\..\Wins\BuildMenu.xaml"
            this.bsearchbuild.Click += new System.Windows.RoutedEventHandler(this.bsearchbuild_Click);
            
            #line default
            #line hidden
            return;
            case 3:
            this.LVUserlist = ((System.Windows.Controls.ListView)(target));
            return;
            case 4:
            this.textboxID = ((System.Windows.Controls.TextBox)(target));
            return;
            case 5:
            this.bbuildid = ((System.Windows.Controls.Button)(target));
            
            #line 107 "..\..\..\..\Wins\BuildMenu.xaml"
            this.bbuildid.Click += new System.Windows.RoutedEventHandler(this.bbuildid_Click);
            
            #line default
            #line hidden
            return;
            case 6:
            this.tbpay = ((System.Windows.Controls.TextBox)(target));
            return;
            }
            this._contentLoaded = true;
        }
    }
}

