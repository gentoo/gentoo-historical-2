# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/magicfilter/magicfilter-1.2-r3.ebuild,v 1.7 2003/09/07 00:18:10 msterret Exp $

inherit eutils

IUSE=""

S=${WORKDIR}/${P}
PATCHDIR=${WORKDIR}/${P}-gentoo
DESCRIPTION="Customizable, extensible automatic printer filter"
HOMEPAGE="http://www.gnu.org/directory/magicfilter.html"
SRC_URI="ftp://metalab.unc.edu/pub/linux/system/printing/${P}.tar.gz
	mirror://gentoo/${P}-gentoo.tar.bz2
	http://cvs.gentoo.org/~seemant/${P}-gentoo.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND=">=app-text/ghostscript-6.50-r2
	>=sys-apps/groff-1.16.1-r1
	>=sys-apps/bzip2-1.0.1-r4
	>=sys-apps/gzip-1.2.4a-r6"

src_unpack() {

	unpack ${A}
	# This is the patch directly from the Debian package.  It's included
	# here (instead of fetching from Debian) because their package
	# revisions will change faster than this ebuild will keep up...
	cd ${S}
	epatch ${PATCHDIR}/magicfilter_1.2-39.diff
	epatch ${PATCHDIR}/magicfilter-1.2-stc777.patch
	cp ${PATCHDIR}/*-filter.x filters || die
}

src_compile() {
	./configure --host="${CHOST}" || die
	emake || die
	# Fixup the filters for /usr/sbin/magicfilter; eventually
	# magicfilterconf should be fixed up for
	# /usr/share/magicfilter/...  :-(
	cd filters
	for f in *-filter; do
		mv $f $f.old
		( read l; echo '#!/usr/sbin/magicfilter'; cat ) <$f.old >$f
	done
}

src_install() {
	into /usr
	dosbin magicfilter magicfilterconfig

	insinto /usr/share/magicfilter
	doins filters/*-filter ${PATCHDIR}/stc777-text-helper

	newman magicfilter.man magicfilter.8
	doman magicfilterconfig.8

	dodoc README QuickInst TODO debian/copyright
	docinto filters
	dodoc filters/README*
}
