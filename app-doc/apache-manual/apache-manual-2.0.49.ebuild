# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/apache-manual/apache-manual-2.0.49.ebuild,v 1.3 2004/06/24 21:38:21 agriffis Exp $

DESCRIPTION="Configures the apache manual for local viewing."
HOMEPAGE="http://www.apache.org"
SRC_URI="http://www.apache.org/dist/httpd/httpd-${PV}.tar.gz"
KEYWORDS="~x86 ~ppc ~hppa ~mips ~sparc ~amd64 ~ia64"
LICENSE="Apache-2.0"
SLOT="0"

DEPEND="=net-www/apache-2*
	>=sys-apps/sed-4"

IUSE=""

S="${WORKDIR}/httpd-${PV}"

src_compile() {
	einfo "Nothing to do."
}

src_install() {
	sed -i -e "s:2.0.49:${PV}" ${FILESDIR}/00_apache_manual.conf
	insinto /etc/apache2/conf/modules.d
	doins ${FILESDIR}/00_apache_manual.conf
}
