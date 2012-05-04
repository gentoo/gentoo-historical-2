# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/nlog/nlog-1.0.ebuild,v 1.5 2012/05/04 03:56:56 jdhore Exp $

EAPI=2

MY_PN=NLog
MY_P=${MY_PN}-${PV}

inherit mono multilib eutils

DESCRIPTION="NLog is a .NET logging library designed with simplicity and flexibility in mind."
HOMEPAGE="http://www.nlog-project.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RDEPEND=">=dev-lang/mono-2.0.1"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-arch/unzip
	dev-dotnet/nant"
S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}/${P}-build.patch"
}

src_compile() {
	nant -t:mono-2.0 -D:warnaserror=false || die "Nant build failed"
}

src_install() {
	for dll in $(find build -name "*.dll")
	do
		pushd $(dirname ${dll}) &> /dev/null
		egacinstall ${dll##*/}
		popd &> /dev/null
	done
	dodir /usr/$(get_libdir)/pkgconfig
	ebegin "Installing .pc file"
	sed  \
		-e "s:@LIBDIR@:$(get_libdir):" \
		-e "s:@PACKAGENAME@:${MY_PN}:" \
		-e "s:@DESCRIPTION@:${DESCRIPTION}:" \
		-e "s:@VERSION@:${PV}:" \
		-e 's;@LIBS@;-r:${libdir}/mono/nlog/NLog.dll;' \
		"${FILESDIR}"/${PN}.pc.in > "${D}"/usr/$(get_libdir)/pkgconfig/${PN}.pc
	PKG_CONFIG_PATH="${D}/usr/$(get_libdir)/pkgconfig/" pkg-config --exists ${PN} || die ".pc file failed to validate."
	eend $?
	dodoc README.txt || die "dodoc failed"
}
