# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/catalyst/catalyst-2.0.3_pre2.ebuild,v 1.2 2007/03/05 03:25:22 genone Exp $

inherit eutils

DESCRIPTION="Gentoo Linux official release metatool"
HOMEPAGE="http://www.gentoo.org/proj/en/releng/catalyst"
SRC_URI="http://dev.gentoo.org/~wolf31o2/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="ccache cdr"

DEPEND=""
RDEPEND="dev-lang/python
	app-crypt/shash
	amd64? ( sys-apps/setarch )
	ppc64? ( sys-apps/setarch )
	ccache? ( dev-util/ccache )
	cdr? (
		virtual/cdrtools
		ia64? ( sys-fs/dosfstools )
		app-misc/zisofs-tools
		>=sys-fs/squashfs-tools-2.1 )"

pkg_setup() {
	if use ccache ; then
		einfo "Enabling ccache support for catalyst."
	else
		ewarn "By default, ccache support for catalyst is disabled."
		ewarn "If this is not what you intended,"
		ewarn "then you should add ccache to your USE."
	fi
	echo
	elog "The template spec files are now installed by default.  You can find"
	elog "them under /usr/share/doc/${PF}/examples"
	elog "and they are considered to be the authorative source of information"
	elog "on catalyst."
}

src_install() {
	insinto /usr/lib/${PN}/arch
	doins arch/* || die "copying arch/*"
	insinto /usr/lib/${PN}/modules
	doins modules/* || die "copying modules/*"
	insinto /usr/lib/${PN}/livecd/cdtar
	doins livecd/cdtar/* || die "copying cdtar/*"
	insinto /usr/lib/${PN}/livecd/files
	doins livecd/files/* || die "copying files/*"
	for x in targets/*; do
		exeinto /usr/lib/${PN}/$x
		doexe $x/* || die "copying ${x}"
	done
	exeinto /usr/lib/${PN}
	doexe catalyst || die "copying catalyst"
	dodir /usr/bin
	dosym /usr/lib/${PN}/catalyst /usr/bin/catalyst
	insinto /etc/catalyst
	doins files/catalyst.conf files/catalystrc || die "copying configuration"
	DOCDESTTREE="." dohtml -A spec,msg,example -r examples files
	dodoc README ChangeLog ChangeLog.old AUTHORS
	doman files/catalyst.1
	# Here is where we actually enable ccache
	use ccache && \
		dosed 's:options="autoresume kern:options="autoresume ccache kern:' \
		/etc/catalyst/catalyst.conf
}

pkg_postinst() {
	elog "You can find more information about catalyst by checking out the"
	elog "catalyst project page at:"
	elog "http://www.gentoo.org/proj/en/releng/catalyst/index.xml"
	echo
}
