# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/docbook-xsl-stylesheets/docbook-xsl-stylesheets-1.75.2.ebuild,v 1.5 2009/09/06 15:24:47 maekke Exp $

DESCRIPTION="XSL Stylesheets for Docbook"
HOMEPAGE="http://wiki.docbook.org/topic/DocBookXslStylesheets"
SRC_URI="mirror://sourceforge/docbook/docbook-xsl-${PV}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ~m68k ~mips ppc ~ppc64 ~s390 ~sh ~sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="test"

DEPEND="
	test? (
		dev-libs/libxml2
		dev-libs/libxslt )"

RDEPEND=">=app-text/build-docbook-catalog-1.1"

S=${WORKDIR}/docbook-xsl-${PV}

# Makefile is broken in this release
RESTRICT=test

# The makefile runs tests, not builds.
src_compile() { :; }

src_test() {
	emake check || die "test failed"
}

src_install() {
	# Create the installation directory
	DEST="/usr/share/sgml/docbook/xsl-stylesheets"
	insinto ${DEST}

	local i
	for sheet in $(find . -maxdepth 1 -mindepth 1 -type d); do
		i=$(basename $sheet)
		cd "${S}"/${i}
		for doc in ChangeLog README; do
			if [ -e "$doc" ]; then
				mv ${doc} ${doc}.${i}
				dodoc ${doc}.${i}
				rm ${doc}.${i}
			fi
		done

		doins -r "${S}"/${i}
	done

	# Install misc. docs
	# The changelog is now zipped, and copied as the RELEASE-NOTES, so we
	# don't need to install it
	cd "${S}"
	dodoc AUTHORS BUGS NEWS README RELEASE-NOTES.txt TODO
	doins VERSION
}

pkg_postinst() {
	build-docbook-catalog
}

pkg_postrm() {
	build-docbook-catalog
}
