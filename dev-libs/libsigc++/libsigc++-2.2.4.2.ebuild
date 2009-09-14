# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libsigc++/libsigc++-2.2.4.2.ebuild,v 1.1 2009/09/14 21:13:39 eva Exp $

EAPI="2"

inherit base eutils gnome.org flag-o-matic

DESCRIPTION="Typesafe callback system for standard C++"
HOMEPAGE="http://libsigc.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc test"

# Needs mm-common for eautoreconf
src_prepare() {
	# don't waste time building examples
	sed -i 's|^\(SUBDIRS =.*\)examples\(.*\)$|\1\2|' Makefile.in || \
		die "sed examples failed"

	# don't waste time building tests unless USE=test
	if ! use test ; then
		sed -i 's|^\(SUBDIRS =.*\)tests\(.*\)$|\1\2|' Makefile.in || \
			die "sed tests failed"
	fi

	# fix image paths
#	if use doc ; then
#		sed -i 's|../../images/||g' docs/reference/html/*.html || \
#			die "sed failed"
#	fi
}

src_compile() {
	filter-flags -fno-exceptions

	local myconf="$myconf $(use_enable doc documentation)"

	econf ${myconf} || die "econf failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed."
	#rm -fr "${D}"/usr/share
	dodoc AUTHORS ChangeLog README NEWS TODO || die "dodoc failed"

	if use doc ; then
		dohtml -r docs/reference/html/* docs/images/* || die "dohtml failed"
		cp -R examples "${D}"/usr/share/doc/${PF}/
	fi
}

pkg_postinst() {
	ewarn "To allow parallel installation of sigc++-1.0, sigc++-1.2, and sigc++2.0"
	ewarn "the header files are now installed in a version specific"
	ewarn "subdirectory.  Be sure to unmerge any libsigc++ versions"
	ewarn "< 1.0.4 that you may have previously installed."
}
