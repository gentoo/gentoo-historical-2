# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/syslog-ng/syslog-ng-2.0.0.ebuild,v 1.1 2006/11/02 20:51:37 mr_bones_ Exp $

inherit fixheadtails

MY_PV=${PV/_/}
DESCRIPTION="syslog replacement with advanced filtering features"
HOMEPAGE="http://www.balabit.com/products/syslog_ng/"
SRC_URI="http://www.balabit.com/downloads/syslog-ng/2.0/src/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="hardened selinux static ipv6"

RDEPEND=">=dev-libs/eventlog-0.2
	>=dev-libs/glib-2.2"
DEPEND="${RDEPEND}
	sys-devel/flex"
PROVIDE="virtual/logger"

S=${WORKDIR}/${PN}-${MY_PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	ht_fix_file configure
	cd "${S}/doc/reference"
	tar xzf syslog-ng.html.tar.gz || die "tar failed"
}

src_compile() {
	econf \
		--sysconfdir=/etc/syslog-ng \
		--disable-dependency-tracking \
		$(use_enable ipv6) \
		$(use_enable !static dynamic-linking) \
		$(use_enable static static-linking) \
		|| die
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README \
		doc/examples/{syslog-ng.conf.sample,syslog-ng.conf.solaris} \
		contrib/syslog-ng.conf* \
		doc/reference/syslog-ng.txt \
		contrib/syslog2ng "${FILESDIR}/syslog-ng.conf."*
	dohtml doc/reference/syslog-ng.html/*

	# Install default configuration
	insinto /etc/syslog-ng
	if use hardened || use selinux ; then
		newins "${FILESDIR}/syslog-ng.conf.gentoo.hardened" syslog-ng.conf
	else
		newins "${FILESDIR}/syslog-ng.conf.gentoo" syslog-ng.conf
	fi

	# Install snippet for logrotate, which may or may not be installed
	insinto /etc/logrotate.d
	newins "${FILESDIR}/syslog-ng.logrotate" syslog-ng

	newinitd "${FILESDIR}/syslog-ng.rc6" syslog-ng
	newconfd "${FILESDIR}/syslog-ng.confd" syslog-ng
}
