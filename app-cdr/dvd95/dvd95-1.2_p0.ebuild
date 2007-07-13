# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/dvd95/dvd95-1.2_p0.ebuild,v 1.2 2007/07/13 05:40:32 mr_bones_ Exp $

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="DVD95 is a Gnome application to convert DVD9 to DVD5."
HOMEPAGE="http://dvd95.sourceforge.net/"
SRC_URI="mirror://sourceforge/dvd95/${MY_P/_/}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE_LINGUAS="linguas_en linguas_fr"
IUSE="${IUSE_LINGUAS} mmx 3dnow sse sse2"

DEPEND="gnome-base/libgnomeui
	media-libs/libdvdread"

RDEPEND="gnome-base/libgnomeui
	media-libs/libdvdread"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i "s#prefix = /usr/local#prefix = /usr#" po/Makefile.in
}

src_compile() {
	# This package provides en and fr for LINGUAS.
	# Default language is French, but switch to English if no LINGUAS is set.

	if [ -z "${LINGUAS}" ]; then
		export LINGUAS="en"
	fi

	econf $(use_enable mmx) \
		$(use_enable 3dnow) \
		$(use_enable sse) \
		$(use_enable sse2) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog COPYING NEWS README
}
