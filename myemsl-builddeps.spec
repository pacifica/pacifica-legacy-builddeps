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
%endif

%prep
%setup -q

%build
make myemslbuilddepssdk.wxs

%install
dir=$RPM_BUILD_ROOT/%{_prefix}/lib/myemsl/builddeps
mkdir -p $dir
rm -f myemsl-builddeps.spec
cp -r code/* $dir/
%if %{use_windows}
mkdir -p "$RPM_BUILD_ROOT/usr/share/myemsl/builddeps"
rm -f "$RPM_BUILD_ROOT/usr/share/myemsl/builddeps"/build-win32.zip
zip -r "$RPM_BUILD_ROOT/usr/share/myemsl/builddeps"/build-win32.zip myemslbuilddepssdk.wxs code
pushd scripts
zip -r "$RPM_BUILD_ROOT/usr/share/myemsl/builddeps"/build-win32.zip bundle.bat
popd
%endif

%clean
rm -rf $RPM_BUILD_ROOT

%if %{use_windows}
%files -n mingw32-myemsl-builddeps-zip
%defattr(-,root,root)
/usr/share/myemsl/builddeps/*
%endif

%files
%defattr(-,root,root)
%{_prefix}/lib/myemsl/builddeps/*
