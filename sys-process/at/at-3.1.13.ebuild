# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/at/at-3.1.13.ebuild,v 1.4 2011/10/10 10:56:16 polynomial-c Exp $

EAPI=4

inherit autotools eutils flag-o-matic pam

DESCRIPTION="Queues jobs for later execution"
HOMEPAGE="http://packages.qa.debian.org/a/at.html"
SRC_URI="mirror://debian/pool/main/a/at/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="pam"

DEPEND="virtual/mta
	>=sys-devel/autoconf-2.64
	>=sys-devel/flex-2.5.4a
	pam? ( virtual/pam )"
RDEPEND="virtual/mta
	virtual/logger"

pkg_setup() {
	enewgroup at 25
	enewuser at 25 -1 /var/spool/at/atjobs at
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.1.8-more-deny.patch
	epatch "${FILESDIR}"/${PN}-3.1.13-Makefile.patch
	# fix parallel make issues, bug #244884
	epatch "${FILESDIR}"/${PN}-3.1.10.2-Makefile.in-parallel-make-fix.patch
	epatch "${FILESDIR}"/${P}-configure.in-fix-PAM-automagick-dep.patch

	eautoconf
}

src_configure() {
	use pam || my_conf="--without-pam"
	econf \
		--sysconfdir=/etc/at \
		--with-jobdir=/var/spool/at/atjobs \
		--with-atspool=/var/spool/at/atspool \
		--with-etcdir=/etc/at \
		--with-daemon_username=at \
		--with-daemon_groupname=at \
		${my_conf}
}

src_install() {
	make install IROOT="${D}" || die

	# Don't install .SEQ file when it's already installed (bug #386625)
	if [ -e "${ROOT}/var/spool/at/atjobs/.SEQ" ] ; then
		rm "${D}/var/spool/at/atjobs/.SEQ" || die
	fi

	newinitd "${FILESDIR}"/atd.rc6 atd
	newconfd "${FILESDIR}"/atd.confd atd
	newpamd "${FILESDIR}"/at.pamd atd
}

pkg_postinst() {
	einfo "Forcing correct permissions on /var/spool/at"
	chown at:at "${ROOT}/var/spool/at/atjobs"
	chmod 1770  "${ROOT}/var/spool/at/atjobs"
	chown at:at "${ROOT}/var/spool/at/atjobs/.SEQ"
	chmod 0600  "${ROOT}/var/spool/at/atjobs/.SEQ"
	chown at:at "${ROOT}/var/spool/at/atspool"
	chmod 1770  "${ROOT}/var/spool/at/atspool"
}
