# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/mono/mono-1.0.2-r1.ebuild,v 1.1 2005/03/11 03:14:01 latexer Exp $

inherit eutils mono flag-o-matic debug gcc

DESCRIPTION="Mono runtime and class libraries, a C# compiler/interpreter"
HOMEPAGE="http://www.go-mono.com/"
SRC_URI="http://www.go-mono.com/archive/${PV}/${P}.tar.gz"

LICENSE="|| ( GPL-2 LGPL-2 X11)"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="nptl"

DEPEND="virtual/libc
	>=dev-libs/glib-2.0
	>=dev-libs/icu-2.6.1
	!<dev-dotnet/pnet-0.6.12
	nptl? ( >=sys-devel/gcc-3.4 )
	ppc? (
		>=sys-devel/gcc-3.2.3-r4
		>=sys-libs/glibc-2.3.3_pre20040420
	)"

RDEPEND="${DEPEND}
	dev-util/pkgconfig
	dev-libs/libxml2"

src_compile() {
	strip-flags

	local myconf=""
	if use nptl && have_NPTL
	then
		# NPTL support only works with gcc-3.4 and higher currently. ):
		if [ `gcc-minor-version` -lt 4 ]
		then
			echo
			eerror "NPTL enabled mono requires gcc-3.4 or higher to function."
			eerror "Please use gcc-config to select gcc-3.4 for the mono installation."
			die "gcc version not high enough for NPTL support."
		else
			myconf="${myconf} --with-tls=__thread"
			sed -i "s: -fexceptions::" ${S}/libgc/configure.host
		fi
	else
		if have_NPTL
		then
			ewarn "NPTL glibc detected, but nptl USE flag is not set."
			ewarn "This may cause some problems for mono as it will be"
			ewarn "compiled with normal pthread support."
		fi

		myconf="${myconf} --with-tls=pthread"
	fi

	econf ${myconf} || die
	emake -j1 || die "MONO compilation failure"
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog NEWS README
	docinto docs
	dodoc docs/*
	docinto libgc
	dodoc libgc/ChangeLog

	# init script
	exeinto /etc/init.d ; newexe ${FILESDIR}/dotnet.init dotnet
	insinto /etc/conf.d ; newins ${FILESDIR}/dotnet.conf dotnet
}

pkg_postinst() {
	echo
	einfo "If you want to avoid typing '<runtime> program.exe'"
	einfo "you can configure your runtime in /etc/conf.d/dotnet"
	einfo "Use /etc/init.d/dotnet to register your runtime"
	echo
}
