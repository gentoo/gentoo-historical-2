# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/realpath/realpath-1.15-r1.ebuild,v 1.5 2010/06/24 21:32:01 pacho Exp $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="Return the canonicalized absolute pathname"
HOMEPAGE="http://packages.debian.org/unstable/utils/realpath"
SRC_URI="mirror://debian/pool/main/r/${PN}/${PN}_${PV}.tar.gz
	nls? ( mirror://debian/pool/main/r/${PN}/${PN}_${PV}_i386.deb )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ~ppc ~ppc64 s390 sh sparc x86"
IUSE="nls"

RDEPEND="!sys-freebsd/freebsd-bin"

src_unpack() {
	unpack ${PN}_${PV}.tar.gz

	if use nls; then
		# Unpack the .deb file, in order to get the preprocessed man page
		# translations. This way we avoid a dependency on app-text/po4a.
		mkdir deb
		cd deb
		unpack ${PN}_${PV}_i386.deb
		unpack ./data.tar.gz
		gunzip -r usr/share/man || die "gunzip failed"
	else
		epatch "${FILESDIR}"/${PN}-1.15-nonls.patch
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.14-build.patch
	epatch "${FILESDIR}"/${PN}-1.14-no-po4a.patch
}

src_compile() {
	tc-export CC
	emake VERSION="${PV}" SUBDIRS="src man $(use nls && echo po)" \
		|| die "emake failed"
}

src_install() {
	emake VERSION="${PV}" SUBDIRS="src man $(use nls && echo po)" \
		DESTDIR="${D}" install || die "emake install failed"
	newdoc debian/changelog ChangeLog.debian

	if use nls; then
		local dir
		for dir in "${WORKDIR}"/deb/usr/share/man/*; do
			[ -f "${dir}"/man1/realpath.1 ] || continue
			newman "${dir}"/man1/realpath.1 realpath.${dir##*/}.1 \
				|| die "newman failed"
		done
	fi
}
