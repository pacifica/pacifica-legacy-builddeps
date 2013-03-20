Name: myemsl-builddeps
Version: 022
Release: 1%{?dist}
Summary: MyEMSL build time dependencies
Group: System Environment/Base
License: UNKNOWN
Source: %{name}-%{version}.tar.gz
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}

%{!?dist: %define dist .el5}

%global mingw32_root /usr/i686-w64-mingw32/sys-root/mingw

%if 0%{?_with_windows:1}
	%global use_windows 1
%else
	%if 0%{?_without_windows:1}
		%global use_windows 0
	%else
		%if %(test x`echo "%{dist}" | cut -c1-3` = 'x.fc' && echo 1 || echo 0)
			%global use_windows 1
		%else
			%global use_windows 0
		%endif
	%endif
%endif

%if %{use_windows}
%global mingw32_root /usr/i686-w64-mingw32/sys-root/mingw
BuildRequires: mingw32-pkg-config mingw32-qt zip unzip
%endif

%description
MyEMSL build time dependencies

%if %{use_windows}
%package -n     mingw32-myemsl-builddeps-zip
Summary:        MyEMSL build time dependencies for windows
Group:          System Environment/Base
Requires: %{name}

%description -n mingw32-myemsl-builddeps-zip
MyEMSL build time dependencies for windows

%package -n     mingw32-qtsolutionsservice
Summary:        QT Solutions Service library
Group:          System Environment/Base
Requires: %{name}

%description -n mingw32-qtsolutionsservice
QT Solutions Service library

%package -n     mingw32-qtsolutionsservice-devel
Summary:        QT Solutions Service library development files
Group:          System Environment/Base
Requires: %{name}

%description -n mingw32-qtsolutionsservice-devel
QT Solutions Service library development files
%endif

%prep
%setup -q

%build
%if %{use_windows}
make clean
mingw32-make UNAME=MINGW32_CROSS QMAKE=i686-w64-mingw32-qmake-qt4 build-prep build-qmake myemslbuilddepssdk.wxs
%endif
make myemslbuilddepssdk.wxs

%install
dir=$RPM_BUILD_ROOT/%{_prefix}/lib/myemsl/builddeps
mkdir -p $dir
rm -f myemsl-builddeps.spec
cp -r code/* $dir/
%if %{use_windows}
BUILDZIP="$RPM_BUILD_ROOT/usr/share/myemsl/builddeps"/build-win32.zip
mkdir -p "$RPM_BUILD_ROOT/usr/share/myemsl/builddeps"
rm -f "$BUILDZIP"
zip -r "$BUILDZIP" myemslbuilddepssdk.wxs qtsolutionsservice.pc code
zip -r "$BUILDZIP" build
pushd scripts
zip -r "$BUILDZIP" bundle.bat
popd
mkdir -p "$RPM_BUILD_ROOT/%{mingw32_root}"
unzip "$BUILDZIP" 'build/lib/*' -d "$RPM_BUILD_ROOT/%{mingw32_root}"
unzip "$BUILDZIP" 'build/include/*' -d "$RPM_BUILD_ROOT/%{mingw32_root}"
unzip "$BUILDZIP" 'build/bin/*' -d "$RPM_BUILD_ROOT/%{mingw32_root}"
mv "$RPM_BUILD_ROOT/%{mingw32_root}/build/lib" "$RPM_BUILD_ROOT/%{mingw32_root}/lib"
mv "$RPM_BUILD_ROOT/%{mingw32_root}/build/include" "$RPM_BUILD_ROOT/%{mingw32_root}/include"
mv "$RPM_BUILD_ROOT/%{mingw32_root}/build/bin" "$RPM_BUILD_ROOT/%{mingw32_root}/bin"
rmdir "$RPM_BUILD_ROOT/%{mingw32_root}/build"
%endif

%clean
rm -rf $RPM_BUILD_ROOT

%if %{use_windows}
%files -n mingw32-myemsl-builddeps-zip
%defattr(-,root,root)
/usr/share/myemsl/builddeps/*

%files -n mingw32-myemsl-builddeps-zip
%defattr(-,root,root)
/usr/share/myemsl/builddeps/*

%files -n mingw32-qtsolutionsservice
%defattr(-,root,root)
%{mingw32_root}/bin/QtSolutions_Service.dll

%files -n mingw32-qtsolutionsservice-devel
%defattr(-,root,root)
%{mingw32_root}/include
%{mingw32_root}/lib/libQtSolutions_Service.a
%{mingw32_root}/lib/pkgconfig
%endif

%files
%defattr(-,root,root)
%{_prefix}/lib/myemsl/builddeps/*
