﻿#pragma checksum "..\..\..\..\Wins\SelectWorker.xaml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "F1274AF9066E8BEC0EE7CF813978C58F02DE7019"
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
    /// SelectWorker
    /// </summary>
    public partial class SelectWorker : System.Windows.Window, System.Windows.Markup.IComponentConnector {
        
        
        #line 20 "..\..\..\..\Wins\SelectWorker.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox tbemail;
        
        #line default
        #line hidden
        
        
        #line 21 "..\..\..\..\Wins\SelectWorker.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button bselectemail;
        
        #line default
        #line hidden
        
        
        #line 25 "..\..\..\..\Wins\SelectWorker.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.ComboBox cbregion;
        
        #line default
        #line hidden
        
        
        #line 26 "..\..\..\..\Wins\SelectWorker.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.ComboBox cbgu;
        
        #line default
        #line hidden
        
        
        #line 27 "..\..\..\..\Wins\SelectWorker.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.ComboBox cbdong;
        
        #line default
        #line hidden
        
        
        #line 30 "..\..\..\..\Wins\SelectWorker.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.ListBox lbworker;
        
        #line default
        #line hidden
        
        private bool _contentLoaded;
        
        /// <summary>
        /// InitializeComponent
        /// </summary>
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "6.0.5.0")]
        public void InitializeComponent() {
            if (_contentLoaded) {
                return;
            }
            _contentLoaded = true;
            System.Uri resourceLocater = new System.Uri("/Ahnduino;component/wins/selectworker.xaml", System.UriKind.Relative);
            
            #line 1 "..\..\..\..\Wins\SelectWorker.xaml"
            System.Windows.Application.LoadComponent(this, resourceLocater);
            
            #line default
            #line hidden
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "6.0.5.0")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Design", "CA1033:InterfaceMethodsShouldBeCallableByChildTypes")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1800:DoNotCastUnnecessarily")]
        void System.Windows.Markup.IComponentConnector.Connect(int connectionId, object target) {
            switch (connectionId)
            {
            case 1:
            this.tbemail = ((System.Windows.Controls.TextBox)(target));
            return;
            case 2:
            this.bselectemail = ((System.Windows.Controls.Button)(target));
            
            #line 21 "..\..\..\..\Wins\SelectWorker.xaml"
            this.bselectemail.Click += new System.Windows.RoutedEventHandler(this.bselectemail_Click);
            
            #line default
            #line hidden
            return;
            case 3:
            this.cbregion = ((System.Windows.Controls.ComboBox)(target));
            return;
            case 4:
            this.cbgu = ((System.Windows.Controls.ComboBox)(target));
            return;
            case 5:
            this.cbdong = ((System.Windows.Controls.ComboBox)(target));
            
            #line 27 "..\..\..\..\Wins\SelectWorker.xaml"
            this.cbdong.SelectionChanged += new System.Windows.Controls.SelectionChangedEventHandler(this.cbdong_SelectionChanged);
            
            #line default
            #line hidden
            return;
            case 6:
            this.lbworker = ((System.Windows.Controls.ListBox)(target));
            return;
            }
            this._contentLoaded = true;
        }
    }
}

