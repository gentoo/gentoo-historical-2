# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mpg321/mpg321-0.2.10-r3.ebuild,v 1.13 2009/06/01 18:03:46 ssuominen Exp $

inherit eutils

DESCRIPTION="Free MP3 player, drop-in replacement for mpg123"
HOMEPAGE="http://sourceforge.net/projects/mpg321"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa -mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/libmad
	media-libs/libid3tag
	media-libs/libao"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# from debian?
	epatch "${FILESDIR}"/${P}-file-descriptors-leak.patch
	# provide an User-Agent when requesting via HTTP
	# By Frank Ruell, in FreeBSD PR 84898
	epatch "${FILESDIR}"/${P}-useragent.patch
}

src_compile() {
	# disabling the symlink here and doing it in postinst is better for GRP
	econf --disable-mpg123-symlink
	emake || die "emake failed."
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS BUGS ChangeLog HACKING NEWS README README.remote THANKS TODO
}

pkg_postinst() {
	# We create a symlink for /usr/bin/mpg123 if it doesn't already exist
	if ! [ -f "${ROOT}"usr/bin/mpg123 ]; then
		ln -s mpg321 "${ROOT}"usr/bin/mpg123
	fi
}

pkg_postrm() {
	# We delete the symlink if it's nolonger valid.
	if [ -L "${ROOT}usr/bin/mpg123" ] && [ ! -x "${ROOT}usr/bin/mpg123" ]; then
		elog "We are removing the ${ROOT}usr/bin/mpg123 symlink since it is no longer valid."
		elog "If you are using another virtual/mpg123 program, you should setup the appropriate symlink."
		rm "${ROOT}"usr/bin/mpg123
	fi
}
