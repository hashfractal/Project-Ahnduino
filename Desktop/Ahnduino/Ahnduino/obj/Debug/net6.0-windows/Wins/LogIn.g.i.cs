﻿#pragma checksum "..\..\..\..\Wins\LogIn.xaml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "E126207747E07DECCE161DF8EE55882CAB1DE353"
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
    /// SignIn
    /// </summary>
    public partial class SignIn : System.Windows.Window, System.Windows.Markup.IComponentConnector {
        
        
        #line 15 "..\..\..\..\Wins\LogIn.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox IDTextbox;
        
        #line default
        #line hidden
        
        
        #line 32 "..\..\..\..\Wins\LogIn.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox PWTextbox;
        
        #line default
        #line hidden
        
        
        #line 48 "..\..\..\..\Wins\LogIn.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button Login_Btn;
        
        #line default
        #line hidden
        
        
        #line 51 "..\..\..\..\Wins\LogIn.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button Register_Btn;
        
        #line default
        #line hidden
        
        
        #line 54 "..\..\..\..\Wins\LogIn.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button ResetPW_Btn;
        
        #line default
        #line hidden
        
        
        #line 57 "..\..\..\..\Wins\LogIn.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button Exit_Btn;
        
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
            System.Uri resourceLocater = new System.Uri("/Ahnduino;component/wins/login.xaml", System.UriKind.Relative);
            
            #line 1 "..\..\..\..\Wins\LogIn.xaml"
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
            
            #line 9 "..\..\..\..\Wins\LogIn.xaml"
            ((Ahnduino.Wins.SignIn)(target)).Loaded += new System.Windows.RoutedEventHandler(this.Window_Loaded);
            
            #line default
            #line hidden
            return;
            case 2:
            this.IDTextbox = ((System.Windows.Controls.TextBox)(target));
            return;
            case 3:
            this.PWTextbox = ((System.Windows.Controls.TextBox)(target));
            return;
            case 4:
            this.Login_Btn = ((System.Windows.Controls.Button)(target));
            
            #line 48 "..\..\..\..\Wins\LogIn.xaml"
            this.Login_Btn.Click += new System.Windows.RoutedEventHandler(this.Login_Btn_Click);
            
            #line default
            #line hidden
            return;
            case 5:
            this.Register_Btn = ((System.Windows.Controls.Button)(target));
            
            #line 51 "..\..\..\..\Wins\LogIn.xaml"
            this.Register_Btn.Click += new System.Windows.RoutedEventHandler(this.Register_Btn_Click);
            
            #line default
            #line hidden
            return;
            case 6:
            this.ResetPW_Btn = ((System.Windows.Controls.Button)(target));
            
            #line 54 "..\..\..\..\Wins\LogIn.xaml"
            this.ResetPW_Btn.Click += new System.Windows.RoutedEventHandler(this.Register_Btn_Click);
            
            #line default
            #line hidden
            return;
            case 7:
            this.Exit_Btn = ((System.Windows.Controls.Button)(target));
            
            #line 57 "..\..\..\..\Wins\LogIn.xaml"
            this.Exit_Btn.Click += new System.Windows.RoutedEventHandler(this.Register_Btn_Click);
            
            #line default
            #line hidden
            return;
            }
            this._contentLoaded = true;
        }
    }
}

