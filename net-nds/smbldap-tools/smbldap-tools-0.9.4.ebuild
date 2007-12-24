# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/smbldap-tools/smbldap-tools-0.9.4.ebuild,v 1.2 2007/12/24 10:49:20 dev-zero Exp $

inherit eutils

DESCRIPTION="Samba LDAP management tools"
HOMEPAGE="https://gna.org/projects/smbldap-tools/
	http://www.iallanis.info/"
SRC_URI="http://download.gna.org/smbldap-tools/packages/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

RDEPEND="net-nds/openldap
	>=net-fs/samba-3.0.1
	dev-perl/perl-ldap
	dev-perl/Crypt-SmbHash
	dev-perl/Digest-SHA1
	dev-perl/Unicode-MapUTF8
	dev-perl/IO-Socket-SSL"
DEPEND="${DEPEND}"

src_compile() {
	for i in smbldap-[gpu]*; do
		pod2man --section=8 $i > $i.8 || die "generation manpage for ${i} failed"
	done
}

src_install() {
	emake install prefix="${D}/usr" sysconfdir="${D}/etc" || die "emake install failed"

	into /usr
	newsbin configure.pl smbldap-configure.pl

	rm -f "${D}/usr/sbin"/*.spec

	dodoc CONTRIBUTORS ChangeLog FILES INFRA README TODO doc/*.conf

	doman *.8

	insinto /usr/share/doc/${PF}
	doins -r doc/migration_scripts
	doins doc/*.pdf
}

pkg_postinst() {
	elog "- A good howto is found on http://www.iallanis.info/smbldap-tools/docs/samba-ldap-howto/"
	elog "- The configure script is installed as smbldap-configure.pl. Please run it to configure the tools."
	elog "- Examples configuration files for Samba and slapd have been copied to /usr/share/doc/${PF},"
	elog "  together with the migration-scripts."
}
