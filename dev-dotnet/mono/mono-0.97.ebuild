# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/mono/mono-0.97.ebuild,v 1.4 2004/06/29 17:08:56 latexer Exp $

inherit eutils mono flag-o-matic

DESCRIPTION="Mono runtime and class libraries, a C# compiler/interpreter"
HOMEPAGE="http://www.go-mono.com/"
SRC_URI="http://www.go-mono.com/archive/rc/${P}.tar.gz"

LICENSE="GPL-2 | LGPL-2 | X11"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="nptl"

DEPEND="virtual/libc
	>=dev-libs/glib-2.0
	>=dev-libs/icu-2.6.1
	!dev-dotnet/pnet
	ppc? ( >=sys-devel/gcc-3.2.3-r4 )
	ppc? ( >=sys-libs/glibc-2.3.3_pre20040420 )"
RDEPEND="${DEPEND}
	dev-util/pkgconfig
	dev-libs/libxml2"

src_unpack() {
	unpack ${A}

	# Make it use the included mono for installing. Problems with DESTDIR.
	sed -i -e "s:\$(DESTDIR)\$(bindir)/mono:\$(mono_runtime) --config ../../data/config:g" \
		${S}/runtime/net_1_1/Makefile.in
}

src_compile() {
	strip-flags

	local myconf=""
	if use nptl && have_NPTL
	then
		myconf="${myconf} --with-nptl=yes"
	else
		myconf="${myconf} --with-nptl=no"
	fi

	econf ${myconf} || die
	emake -j1 || die "MONO compilation failure"
}

src_install() {
	make DESTDIR=${D} install || die
	# einstall || die

	dodoc AUTHORS ChangeLog NEWS README
	docinto docs
	dodoc docs/*

	# install mono's logo
	insopts -m0644
	insinto /usr/share/pixmaps/mono
	doins MonoIcon.png ScalableMonoIcon.svg

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
