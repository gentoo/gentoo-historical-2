# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/mit-krb5-appl/mit-krb5-appl-1.0.1.ebuild,v 1.1 2010/05/23 04:00:15 darkside Exp $

EAPI="2"

inherit flag-o-matic versionator

MY_P=${P/mit-}
MAJOR_MINOR="$( get_version_component_range 1-2 )"
DESCRIPTION="Kerberized applications split from the main MIT Kerberos V distribution"
HOMEPAGE="http://web.mit.edu/kerberos/www/"
SRC_URI="http://web.mit.edu/kerberos/dist/krb5-appl/${MAJOR_MINOR}/${MY_P}-signed.tar"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

RDEPEND=">=app-crypt/mit-krb5-1.8.0"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	unpack ./"${MY_P}".tar.gz
}

src_configure() {
	append-flags "-I/usr/include/et"
	econf
}

src_compile() {
	emake || die "emake failed"
}

src_install() {

	emake DESTDIR="${D}" install || die "make install failed"
	for i in {telnetd,ftpd} ; do
	    mv "${D}"/usr/share/man/man8/${i}.8 "${D}"/usr/share/man/man8/k${i}.8 \
		|| die "mv failed (man)"
	    mv "${D}"/usr/sbin/${i} "${D}"/usr/sbin/k${i} || die "mv failed"
	done

	for i in {rcp,rlogin,rsh,telnet,ftp} ; do
	   	mv "${D}"/usr/share/man/man1/${i}.1 "${D}"/usr/share/man/man1/k${i}.1 \
		|| die "mv failed (man)"
	    mv "${D}"/usr/bin/${i} "${D}"/usr/bin/k${i} || die "mv failed"
	done

	rm "${D}"/usr/share/man/man1/tmac.doc
	dodoc README

}
