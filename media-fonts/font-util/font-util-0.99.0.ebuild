# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/font-util/font-util-0.99.0.ebuild,v 1.8 2005/10/19 04:42:31 geoman Exp $

# Must be before x-modular eclass is inherited
SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="BigReqs prototype headers"
KEYWORDS="~amd64 ~arm ~ia64 ~mips ~ppc ~s390 ~sh ~sparc ~x86"
RDEPEND=""
DEPEND="${RDEPEND}"

src_unpack() {
	x-modular_unpack_source
	x-modular_patch_source

	# This use of datadir in configure.ac requires me to pass --datadir to
	# configure, in addition to the --prefix that's all that is required by
	# other packages.
	sed -i -e "s:^mapdir.*:mapdir=\"\$datadir/fonts/util\":g" \
		${S}/configure.ac

	x-modular_reconf_source
}
