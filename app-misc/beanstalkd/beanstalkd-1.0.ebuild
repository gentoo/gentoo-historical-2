# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/beanstalkd/beanstalkd-1.0.ebuild,v 1.1 2008/08/15 21:24:34 caleb Exp $

inherit eutils

DESCRIPTION="A fast, distributed, in-memory workqueue service"
HOMEPAGE="http://xph.us/software/beanstalkd/"
SRC_URI="http://xph.us/software/beanstalkd/rel/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"

RDEPEND=">=dev-libs/libevent-1.3"
DEPEND="${RDEPEND}"

IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/Makefile.install.patch"
}

src_compile() {
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."

	dodoc README TODO doc/*.txt

	newconfd "${FILESDIR}/conf" beanstalkd
	newinitd "${FILESDIR}/init" beanstalkd
}

pkg_postinst() {
	enewuser beanstalk -1 -1 /dev/null daemon
}
