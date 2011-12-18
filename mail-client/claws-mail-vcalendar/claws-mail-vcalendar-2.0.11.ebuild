# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-vcalendar/claws-mail-vcalendar-2.0.11.ebuild,v 1.5 2011/12/18 18:09:44 armin76 Exp $

EAPI=4

inherit multilib

MY_P="${P#claws-mail-}"

DESCRIPTION="Plugin for Claws to support the vCalendar meeting format"
HOMEPAGE="http://www.claws-mail.org/"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~ppc64 sparc x86"
IUSE=""
RDEPEND=">=mail-client/claws-mail-3.7.10
		>=net-misc/curl-7.9.7"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README

	# kill useless files
	rm -f "${D}"/usr/$(get_libdir)/claws-mail/plugins/*.{a,la}

	# going to conflict with libical
	rm -f "${D}"/usr/include/ical.h
}
