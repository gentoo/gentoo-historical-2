# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-esim4/embassy-esim4-1.0.0-r4.ebuild,v 1.1 2007/07/18 01:35:55 ribosome Exp $

EBOV="5.0.0"

inherit embassy

DESCRIPTION="EMBOSS integrated version of sim4 - Alignment of cDNA and genomic DNA"
SRC_URI="ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-${EBOV}.tar.gz
	mirror://gentoo/embassy-${EBOV}-${PN:8}-${PV}.tar.gz"

KEYWORDS="~amd64 ~ppc ~sparc ~x86"
