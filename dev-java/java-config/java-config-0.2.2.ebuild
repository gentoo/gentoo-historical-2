# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Karl Trygve Kalleberg <karltk@gentoo.org>
# Author: Karl Trygve Kalleberg <karltk@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-java/java-config/java-config-0.2.2.ebuild,v 1.1 2002/04/10 15:46:20 karltk Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Gentoo-specific configuration for Java"
SRC_URI=""
HOMEPAGE="http://www.gentoo.org/~karltk/java-config"
DEPEND=""
#RDEPEND=""

src_install () {
	dobin ${FILESDIR}/java-config
	doman ${FILESDIR}/java-config.1
}
