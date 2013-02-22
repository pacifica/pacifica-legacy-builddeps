Name: myemsl-builddeps
Version: 019
Release: 1%{?dist}
Summary: MyEMSL build time dependencies
Group: System Environment/Base
License: UNKNOWN
Source: %{name}-%{version}.tar.gz
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}

%description
MyEMSL build time dependencies

%prep
%setup -q

%build
echo "Nothing to Build"

%install
dir=$RPM_BUILD_ROOT/%{_prefix}/lib/myemsl/builddeps
mkdir -p $dir
rm -f myemsl-builddeps.spec
cp -r code/* $dir/

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%{_prefix}/lib/myemsl/builddeps/*
