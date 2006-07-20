# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-domainatrix/embassy-domainatrix-0.1.0.ebuild,v 1.5 2006/07/20 21:00:24 ribosome Exp $

EBOV="3.0.0"

inherit embassy

DESCRIPTION="Protein domain analysis add-on package for EMBOSS"
SRC_URI="ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-${EBOV}.tar.gz
	ftp://emboss.open-bio.org/pub/EMBOSS/old/${EBOV}/${EF}.tar.gz"

RESTRICT="nomirror"

KEYWORDS="ppc ppc-macos x86"
