# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/at/at-3.1.10.1.ebuild,v 1.3 2008/10/29 12:45:26 flameeyes Exp $

inherit eutils flag-o-matic

DESCRIPTION="Queues jobs for later execution"
HOMEPAGE="http://packages.qa.debian.org/a/at.html"
SRC_URI="mirror://debian/pool/main/a/at/at_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="virtual/mta
	>=sys-devel/flex-2.5.4a"
RDEPEND="virtual/mta
	virtual/logger"

pkg_setup() {
	enewgroup at 25
	enewuser at 25 -1 /var/spool/at/atjobs at
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-3.1.8-more-deny.patch
	epatch "${FILESDIR}"/${P}-Makefile.patch
}

src_compile() {
	econf \
		--sysconfdir=/etc/at \
		--with-jobdir=/var/spool/at/atjobs \
		--with-atspool=/var/spool/at/atspool \
		--with-etcdir=/etc/at \
		--with-daemon_username=at \
		--with-daemon_groupname=at \
		|| die "configure failed"

	# Parallel make issues, bug #244884
	emake -j1 || die "make failed"
}

src_install() {
	make install IROOT="${D}" || die
	touch "${D}"/var/spool/at/at{jobs,spool}/.SEQ

	newinitd "${FILESDIR}"/atd.rc6 atd
	prepalldocs
}
