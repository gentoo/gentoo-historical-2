# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_krb5/pam_krb5-4.2.ebuild,v 1.1 2010/05/21 19:25:06 flameeyes Exp $

EAPI="2"

inherit multilib

DESCRIPTION="Kerberos 5 PAM Authentication Module"
HOMEPAGE="http://www.eyrie.org/~eagle/software/pam-krb5"
SRC_URI="http://archives.eyrie.org/software/kerberos/pam-krb5-${PV}.tar.gz"

LICENSE="|| ( BSD-2 GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="virtual/krb5
		virtual/pam"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${P/_/-}"

src_configure() {
	econf \
		  --libdir=/$( get_libdir )
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc NEWS README TODO

	# should not be necessary for a pam plugin
	# also shouldnotlink=yes
	rm "${D}/$( get_libdir )/security/pam_krb5.la"
}
