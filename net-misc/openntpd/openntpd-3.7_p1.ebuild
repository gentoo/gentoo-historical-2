# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/openntpd/openntpd-3.7_p1.ebuild,v 1.12 2006/03/31 21:48:01 flameeyes Exp $

inherit eutils

MY_P=${P/_/}
DESCRIPTION="Lightweight NTP server ported from OpenBSD"
HOMEPAGE="http://www.openntpd.org/"
SRC_URI="mirror://openbsd/OpenNTPD/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE="ssl selinux"

RDEPEND="ssl? ( dev-libs/openssl )
	selinux? ( sec-policy/selinux-ntp )
	!<=net-misc/ntp-4.2.0-r2"
DEPEND="${RDEPEND}
	>=sys-apps/portage-2.0.51"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewgroup ntp 123
	enewuser ntp 123 -1 /var/empty ntp

	if ! built_with_use net-misc/ntp openntpd ; then
		die "you need to emerge ntp with USE=openntpd"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i '/NTPD_USER/s:_ntp:ntp:' ntpd.h || die
}

src_compile() {
	econf \
		--disable-strip \
		$(use_with !ssl builtin-arc4random) || die
	emake || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc ChangeLog CREDITS README

	newinitd "${FILESDIR}"/openntpd.rc ntpd
	newconfd "${FILESDIR}"/openntpd.conf.d ntpd
}
