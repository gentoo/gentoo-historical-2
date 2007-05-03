# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-vcalendar/claws-mail-vcalendar-1.95.ebuild,v 1.4 2007/05/03 16:48:24 armin76 Exp $

inherit eutils

MY_P="${P#claws-mail-}"

DESCRIPTION="Plugin for sylpheed-claws to support the vCalendar meeting format"
HOMEPAGE="http://www.claws-mail.org"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc64 sparc x86"
IUSE=""
DEPEND=">=mail-client/claws-mail-2.9.0"

S="${WORKDIR}/${MY_P}"

src_install() {
	make DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README

	# kill useless files
	rm -f ${D}/usr/lib*/claws-mail/plugins/*.{a,la}

	# going to conflict with libical
	rm -f ${D}/usr/include/ical.h
}
