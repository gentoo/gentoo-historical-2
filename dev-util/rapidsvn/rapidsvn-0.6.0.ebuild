# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/rapidsvn/rapidsvn-0.6.0.ebuild,v 1.2 2004/06/25 02:44:54 agriffis Exp $

DESCRIPTION="Cross-platform GUI front-end for the Subversion revision system."
HOMEPAGE="http://rapidsvn.tigris.org/"
SRC_URI="http://www.rapidsvn.org/download/${P}.tar.gz"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE="doc"

DEPEND=">=dev-util/subversion-1.0.0
	>=x11-libs/wxGTK-2.4.2
	doc? ( dev-libs/libxslt app-text/docbook-sgml-utils app-doc/doxygen )"

S=${WORKDIR}/${P}

src_compile() {
	# if you compiled subversion without (the) apache2 (flag) and with the berkdb flag
	# you will get an error that it can't find the lib db4
	local myconf
	#needs manpages support in docbook, gentoo doesn't seem to have this - i dunno
	use doc && myconf="--with-docbook-xsl=/usr/share/sgml/docbook/" \
		|| myconf="--without-xsltproc --without-docbook-xsl --without-doxygen \
			--without-dot"
	econf	--with-svn-lib=/usr/lib \
		--with-svn-include=/usr/include \
		${myconf} || die "./configure failed"
	emake  || die
}

src_install() {
	einstall || die
}

