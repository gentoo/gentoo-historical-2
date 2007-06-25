# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/log4net/log4net-1.2.10.ebuild,v 1.2 2007/06/25 00:59:49 jurek Exp $

inherit eutils mono

DESCRIPTION="tool to help the programmer output log statements to a variety of output targets."
HOMEPAGE="http://logging.apache.org/log4net/"
SRC_URI="http://cvs.apache.org/dist/incubator/${PN}/${PV}/incubating-${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc examples"

DEPEND=">=dev-lang/mono-1.2.1
		dev-dotnet/nant
		app-arch/unzip"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Removing unnecessary precompiled binaries
	elog "Removing precompiled binaries"

	rm -rf bin/*
}

src_compile() {
	/usr/bin/sn -k ${PN}.snk
	/usr/bin/nant || die "build failed"
}

src_install() {
	insinto /usr/$(get_libdir)/${PN}
	doins bin/mono/1.0/release/${PN}.dll

	dodir /usr/$(get_libdir)/pkgconfig
	sed -e "s:@VERSION@:${PV}:" \
		-e "s:@LIBDIR@:$(get_libdir):" \
		${FILESDIR}/${PN}.pc.in > ${D}/usr/$(get_libdir)/pkgconfig/${PN}.pc

	/usr/bin/gacutil /i bin/mono/1.0/release/${PN}.dll \
		/check_refs /root ${D}/usr/$(get_libdir)

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r doc/*
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi

	dodoc README.txt NOTICE.txt
}
