# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/alock/alock-60-r3.ebuild,v 1.6 2009/08/16 09:29:02 betelgeuse Exp $

EAPI="2"

inherit eutils

DESCRIPTION="locks the local X display until a password is entered"
HOMEPAGE="http://code.google.com/p/alock/
	http://darkshed.net/projects/alock"
SRC_URI="http://alock.googlecode.com/files/alock-svn-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="imlib pam"

DEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	imlib? ( media-libs/imlib2[X] )
	pam? ( virtual/pam )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/alock-svn-${PV}

src_prepare() {
	sed -i 's|\$(DESTDIR)\$(prefix)/man|\$(DESTDIR)\$(prefix)/share/man|g' \
		"${S}"/Makefile || die "sed failed"
}

src_configure() {
	econf --with-all \
		$(use_with pam) \
		$(use_with imlib) \
	|| die "configure failed"
}

src_install() {
	dobin src/alock || die
	doman alock.1 || die
	dodoc README.txt LICENSE.txt CHANGELOG.txt || die

	insinto /usr/share/alock/xcursors
	doins contrib/xcursor-* || die

	insinto /usr/share/alock/bitmaps
	doins bitmaps/* || die
}

pkg_postinst() {
	if ! use pam; then
		einfo "pam support disabled"
		einfo "In order to authenticate against /etc/passwd, "
		einfo "/usr/bin/alock will need to be SUID"
	fi
}
