# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/imlib2/imlib2-1.1.1.20040515.ebuild,v 1.1 2004/05/16 19:33:19 vapier Exp $

inherit enlightenment flag-o-matic gcc

DESCRIPTION="Version 2 of an advanced replacement library for libraries like libXpm"
HOMEPAGE="http://www.enlightenment.org/pages/imlib2.html"

IUSE="${IUSE} mmx gif png jpeg tiff static X"

DEPEND="=media-libs/freetype-2*
	gif? ( media-libs/libungif
		>=media-libs/giflib-4.1.0 )
	png? ( >=media-libs/libpng-1.2.1 )
	jpeg? ( media-libs/jpeg )
	tiff? ( >=media-libs/tiff-3.5.5 )
	X? ( virtual/x11 )"

S=${WORKDIR}/${PN}		# cvs
#S=${WORKDIR}/${P}		# release

src_compile() {
	local mymmx=""
	if [ "${ARCH}" == "amd64" ] ; then
		mymmx="--disable-mmx"
	else
		mymmx="`use_enable mmx`"
	fi

	if [ "${S}" == "${WORKDIR}/${PN}" ] ; then
		sed -i '/^SUBDIRS/s:test demo::' Makefile.am
		export MY_ECONF="
			${mymmx} \
			`use_with X x` \
		"
		EHACKAUTOGEN=yes
		enlightenment_src_compile
	else
		econf \
			${mymmx} \
			`use_with X x` \
			|| die "could not configure"
		emake || die "could not make"
	fi
}

src_install() {
	enlightenment_src_install
	docinto samples
	dodoc demo/*.c
}
