# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-acpi-notifier/claws-mail-acpi-notifier-1.0.5.ebuild,v 1.2 2007/01/25 07:58:07 opfer Exp $

inherit eutils

MY_P="${P#claws-mail-}"
MY_P="${MY_P/-/_}"

DESCRIPTION="This plugin enables mail notification via LEDs on some laptops."
HOMEPAGE="http://www.claws-mail.org"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""
DEPEND=">=mail-client/claws-mail-2.6.1"

S="${WORKDIR}/${MY_P}"

src_install() {
	make DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README

	# kill useless files
	rm -f ${D}usr/lib*/claws-mail/plugins/*.{a,la}
}

pkg_postinst() {
	PROC_IFACES="$(echo /proc/acpi/{asus/mled,ibm/led,acer/mailled}) /proc/driver/acerhk/led"

	local procfile
	local message_shown=false

	for procfile in ${PROC_IFACES}; do
		if [[ -f ${procfile} ]]; then
			elog "Make sure ${procfile} is writable by users of this plugin."
			message_shown=true
		fi
	done
}
