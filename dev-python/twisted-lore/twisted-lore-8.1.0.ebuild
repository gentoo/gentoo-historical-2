# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-lore/twisted-lore-8.1.0.ebuild,v 1.3 2008/08/12 18:41:26 armin76 Exp $

MY_PACKAGE=Lore

inherit twisted versionator

DESCRIPTION="Twisted documentation system"

KEYWORDS="alpha ~amd64 ia64 ~ppc sparc x86"

DEPEND="=dev-python/twisted-$(get_version_component_range 1-2)*
	dev-python/twisted-web"
